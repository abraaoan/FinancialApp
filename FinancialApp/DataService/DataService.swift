//
//  DataService.swift
//  FinancialApp
//
//  Created by Abraao Nascimento on 16/10/2023.
//

import XCAStocksAPI

protocol DataServiceProtocol {
    func searchTickers(query: String, isEquityTypeOnly: Bool) async throws -> [Ticker]
    func fetchQuotes(symbols: String) async throws -> [Quote]
    func fetchChartData(tickerSymbol: String, range: ChartRange) async throws -> ChartData?
}

extension XCAStocksAPI: DataServiceProtocol {}
