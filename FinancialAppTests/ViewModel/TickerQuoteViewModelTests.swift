//
//  TickerQuoteViewModelTests.swift
//  FinancialAppTests
//
//  Created by Abraao Nascimento on 17/10/2023.
//

import XCTest
import XCAStocksAPI
@testable import FinancialApp

final class TickerQuoteViewModelTests: XCTestCase {
    @MainActor func testFetchQuoteResult() async {
        // Given
        let ticker = Ticker.stub
        let quotes = Quote.stubs
        var dataService = MockStocksAPI()
        
        // When
        dataService.stubbedFetchQuotesCallback = { quotes }
        let sut = TickerQuoteViewModel(ticker: ticker, dataService: dataService)
        await sut.fetchQuote()
        
        // Then
        XCTAssertEqual(sut.selectQuote, quotes.first)
    }
}
