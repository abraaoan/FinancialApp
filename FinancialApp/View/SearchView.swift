//
//  SearchView.swift
//  FinancialApp
//
//  Created by Abraao Nascimento on 16/10/2023.
//

import SwiftUI
import XCAStocksAPI

struct SearchView<SearchViewModelObservable>: View where SearchViewModelObservable: SearchViewModelProtocol {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: SearchViewModelObservable
    
    var body: some View {
        NavigationView {
            List(viewModel.tickers) { ticker in
                VStack(alignment: .leading, spacing: 8) {
                    Text(ticker.symbol).font(.headline.bold())
                    if let name = ticker.longname {
                        Text(name)
                            .font(.subheadline)
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                    }
                }.onTapGesture {
                    viewModel.selectedTicker = ticker
                    dismiss()
                }
            }
            .listStyle(.plain)
            .searchable(text: $viewModel.query, prompt: "Search an entity")
            .overlay(searchOverlay)
        }
    }
    
    @ViewBuilder
    private var searchOverlay: some View {
        switch viewModel.searchState {
        case .empty: EmptyResultView(message: viewModel.emptyListText)
        case .failure(let error):
            ErrorView(error: error.localizedDescription) {
                Task { await viewModel.searchTickers() }
            }
        case .loading: LoadingView()
        default: EmptyView()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static let viewModel = SearchViewModel()
    static var previews: some View {
        SearchView(viewModel: viewModel)
    }
}
