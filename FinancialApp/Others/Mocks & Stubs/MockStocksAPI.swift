//
//  MockStocksAPI.swift
//  StocksApp
//
//  Created by Alfian Losari on 01/10/22.
//

import Foundation
import XCAStocksAPI

#if DEBUG
struct MockStocksAPI: DataServiceProtocol {
    var stubbedSearchTickersCallback: (() async throws -> [Ticker])?
    func searchTickers(query: String, isEquityTypeOnly: Bool) async throws -> [Ticker] {
        guard let tickets = try await stubbedSearchTickersCallback?() else {
            throw MockSearchError.noTickersSet
        }
        
        return tickets
    }
    
    var stubbedFetchQuotesCallback: (() async throws -> [Quote])!
    func fetchQuotes(symbols: String) async throws -> [Quote] {
        try await stubbedFetchQuotesCallback()
    }
    
    var stubbedFetchChartDataCallback: ((ChartRange) async throws  -> ChartData?)! = { $0.stubs }
    func fetchChartData(tickerSymbol: String, range: ChartRange) async throws -> ChartData? {
        try await stubbedFetchChartDataCallback(range)
    }
    
}

enum MockSearchError: Error {
    case noTickersSet
}

#endif
