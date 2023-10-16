//
//  SearchViewModel.swift
//  FinancialApp
//
//  Created by Abraao Nascimento on 16/10/2023.
//

import Foundation
import Combine
import SwiftUI
import XCAStocksAPI

protocol SearchViewModelProtocol: ObservableObject {
    var query: String { get set }
    var tickers: [Ticker] { get }
    var selectedTicker: Ticker? { get set }
    var error: Error? { get }
    var isSearching: Bool { get }
    var emptyListText: String { get }
    var searchState: RequestState { get }
    
    func searchTickers() async
}

@MainActor
class SearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var selectedTicker: Ticker?
    @Published var searchState: RequestState = .initial
    var tickers: [Ticker] = []
    var error: Error?
    var isSearching: Bool { !trimmedQuery.isEmpty }
    var emptyListText: String { "Not found for\n\"\(query)\"" }
    
    private var trimmedQuery: String { query.trimmingCharacters(in: .whitespacesAndNewlines) }
    private var cancellables = Set<AnyCancellable>()
    private let dataService: DataServiceProtocol
    
    init(query: String = "", dataService: DataServiceProtocol = XCAStocksAPI()) {
        self.query = query
        self.dataService = dataService
        
        startObserving()
    }
    
    private func startObserving() {
        $query
            .debounce(for: 0.25, scheduler: DispatchQueue.main)
            .sink { _ in Task { [weak self] in await self?.searchTickers() } }
            .store(in: &cancellables)
        
        $query
            .filter { $0.isEmpty }
            .sink { [weak self] _ in self?.searchState = .initial }
            .store(in: &cancellables)
    }
}

extension SearchViewModel: SearchViewModelProtocol {
    func searchTickers() async {
        let searchQuery = trimmedQuery
        guard !searchQuery.isEmpty else { return }
        searchState = .loading
        
        do {
            let tickers = try await dataService.searchTickers(query: searchQuery, isEquityTypeOnly: true)
            if searchQuery != trimmedQuery { return }
            if tickers.isEmpty {
                searchState = .empty
            } else {
                self.tickers = tickers
                searchState = .success
            }
        } catch {
            if searchQuery != trimmedQuery { return }
            print(error.localizedDescription)
            await MainActor.run(body: { [weak self] in self?.searchState = .failure(error) })
        }
    }
}
