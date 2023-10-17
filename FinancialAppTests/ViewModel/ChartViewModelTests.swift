//
//  ChartViewModelTests.swift
//  FinancialAppTests
//
//  Created by Abraao Nascimento on 17/10/2023.
//

import XCTest
import XCAStocksAPI
@testable import FinancialApp

final class ChartViewModelTests: XCTestCase {

    @MainActor func testFetchDataResult() async {
        // Given
        let ticker = Ticker.stub
        let dataService = MockStocksAPI()
        
        // When
        let sut = ChartViewModel(ticker: ticker, dataService: dataService)
        await sut.fetchData()
        
        // Then
        XCTAssertEqual(sut.chartState, .success)
    }
}
