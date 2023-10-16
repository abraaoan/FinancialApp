//
//  TickerQuoteViewModel.swift
//  FinancialApp
//
//  Created by Abraao Nascimento on 16/10/2023.
//

import Foundation
import XCAStocksAPI

protocol TickerQuoteViewModelProtocol: ObservableObject {
    var tickerQuotetate: RequestState { get }
    var selectQuote: Quote? { get }
    
    func fetchQuote() async
}

@MainActor
class TickerQuoteViewModel: ObservableObject {
    @Published var tickerQuotetate: RequestState = .initial
    var selectQuote: Quote?

    let ticker: Ticker
    private let dataService: DataServiceProtocol
    
    init(ticker: Ticker, dataService: DataServiceProtocol) {
        self.ticker = ticker
        self.dataService = dataService
    }
}

extension TickerQuoteViewModel: TickerQuoteViewModelProtocol {
    func fetchQuote() async {
        tickerQuotetate = .loading
        
        do {
            let response = try await dataService.fetchQuotes(symbols: ticker.symbol)
            if let quote = response.first {
                selectQuote = quote
                tickerQuotetate = .success
            } else {
                tickerQuotetate = .empty
            }
        } catch {
            print(error.localizedDescription)
            tickerQuotetate = .failure(error)
        }
    }
}
