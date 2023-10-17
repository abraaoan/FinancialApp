//
//  SearchViewModelTests.swift
//  FinancialAppTests
//
//  Created by Abraao Nascimento on 16/10/2023.
//

import XCTest
import XCAStocksAPI
@testable import FinancialApp

final class SearchViewModelTests: XCTestCase {
    
    @MainActor func testSearchTickersResult() async {
        // Given
        let query = "APPL"
        var dataService = MockStocksAPI()
        let tickets = Ticker.stubs
        
        // When
        dataService.stubbedSearchTickersCallback = { tickets }
        let sut = SearchViewModel(query: query, dataService: dataService)
        await sut.searchTickers()
        
        // Then
        XCTAssertGreaterThan(sut.tickers.count, 0)
        XCTAssertEqual(sut.tickers.first, tickets.first)
        XCTAssertEqual(sut.searchState, .success)
    }
    
    @MainActor func testSearchTickersNoResult() async {
        // Given
        let query = "APPL"
        var dataService = MockStocksAPI()
        
        // When
        dataService.stubbedSearchTickersCallback = { [] }
        let sut = SearchViewModel(query: query, dataService: dataService)
        await sut.searchTickers()
        
        // Then
        XCTAssertEqual(sut.tickers.count, 0)
        XCTAssertEqual(sut.searchState, .empty)
        XCTAssertEqual(sut.emptyListText, "Not found for\n\"\(query)\"")
    }
    
    @MainActor func testSearchTickersError() async {
        // Given
        let query = "APPL"
        var dataService = MockStocksAPI()
        
        // When
        let sut = SearchViewModel(query: query, dataService: dataService)
        await sut.searchTickers()
        
        // Then
        XCTAssertEqual(sut.searchState, .failure(MockSearchError.noTickersSet))
    }

}
