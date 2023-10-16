//
//  StockTickerView.swift
//  StocksApp
//
//  Created by Alfian Losari on 16/10/22.
//

import SwiftUI
import XCAStocksAPI

struct StockTickerView: View {
    @StateObject var chartViewModel: ChartViewModel
    @StateObject var quoteViewModel: TickerQuoteViewModel
    @Binding var isShowingSearch: Bool
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerView.padding(.horizontal)
            
            Divider()
                .padding(.vertical, 8)
                .padding(.horizontal)
            scrollView
        }
        .padding(.top)
        .background(Color(uiColor: .systemBackground))
        .task(id: chartViewModel.selectedRange.rawValue) {
            if quoteViewModel.selectQuote == nil {
                await quoteViewModel.fetchQuote()
            }
            await chartViewModel.fetchData()
        }
    }
    
    private var scrollView: some View {
        ScrollView {
            priceDiffRowView
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 8)
                .padding(.horizontal)
            
            Divider()
            
            ZStack {
                DateRangePickerView(selectedRange: $chartViewModel.selectedRange)
                    .opacity(chartViewModel.selectedXOpacity)
                
                Text(chartViewModel.selectedXDateText)
                    .font(.headline)
                    .padding(.vertical, 4)
                    .padding(.horizontal)
            }
            
            
            Divider().opacity(chartViewModel.selectedXOpacity)
            
            chartView
                .padding(.horizontal)
                .frame(maxWidth: .infinity, minHeight: 220)
            
            Divider().padding([.horizontal, .top])
            
            quoteDetailRowView
                .frame(maxWidth: .infinity, minHeight: 80)
            
            
        }
        .scrollIndicators(.hidden)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private var chartView: some View {
        switch chartViewModel.chartState {
        case .loading: LoadingView()
        case .success:
            if let data = chartViewModel.selectedChart {
                ChartView(data: data, viewModel: chartViewModel)
            }
        case .failure(let error):
            ErrorView(error: "Chart: \(error.localizedDescription)")
        default: EmptyView()
        }
    }
    
    @ViewBuilder
    private var quoteDetailRowView: some View {
        switch quoteViewModel.tickerQuotetate {
        case .loading: LoadingView()
        case .failure(let error): ErrorView(error: "Quote: \(error.localizedDescription)")
        case .success:
            if let quote = quoteViewModel.selectQuote {
                ScrollView(.horizontal) {
                    HStack(spacing: 16) {
                        ForEach(quote.columnItems) {
                            QuoteDetailRowColumnView(item: $0)
                        }
                    }
                    .padding(.horizontal)
                    .font(.caption.weight(.semibold))
                    .lineLimit(1)
                }
                .scrollIndicators(.hidden)
            }
            
        default: EmptyView()
        }
    }
    
    private var priceDiffRowView: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let quote = quoteViewModel.selectQuote {
                HStack {
                    if quote.isTrading,
                       let price = quote.regularPriceText,
                       let diff = quote.regularDiffText {
                        priceDiffStackView(price: price, diff: diff, caption: nil)
                    } else {
                        if let atCloseText = quote.regularPriceText,
                           let atCloseDiffText = quote.regularDiffText {
                            priceDiffStackView(price: atCloseText, diff: atCloseDiffText, caption: "At Close")
                        }
                        
                        if let afterHourText = quote.postPriceText,
                           let afterHourDiffText = quote.postPriceDiffText {
                            priceDiffStackView(price: afterHourText, diff: afterHourDiffText, caption: "After Hours")
                        }
                    }
                    
                    Spacer()
                }
            }
            exchangeCurrencyView
        }
    }
    
    private var exchangeCurrencyView: some View {
        HStack(spacing: 4) {
            if let exchange = quoteViewModel.ticker.exchDisp {
                Text(exchange)
            }
            
            if let currency = quoteViewModel.selectQuote?.currency {
                Text("·")
                Text(currency)
            }
        }
        .font(.subheadline.weight(.semibold))
        .foregroundColor(Color(uiColor: .secondaryLabel))
    }
    
    private func priceDiffStackView(price: String, diff: String, caption: String?) -> some View {
        VStack(alignment: .leading) {
            HStack(alignment: .lastTextBaseline, spacing: 16) {
                Text(price).font(.headline.bold())
                Text(diff).font(.subheadline.weight(.semibold))
                    .foregroundColor(diff.hasPrefix("-") ? .red : .green)
            }
            
            if let caption {
                Text(caption)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(Color(uiColor: .secondaryLabel))
            }
        }
    }
    
    private var headerView: some View {
        HStack(alignment: .lastTextBaseline) {
            Text(quoteViewModel.ticker.symbol).font(.title.bold())
            if let shortName = quoteViewModel.ticker.shortname {
                Text(shortName)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(Color(uiColor: .secondaryLabel))
            }
            Spacer()
            searchButton
        }
    }
    
    private var searchButton: some View {
        Button {
            Task {
                await dismissStockView()
                await showSearch()
            }
        } label: {
            Circle()
                .frame(width: 36, height: 36)
                .foregroundColor(.gray.opacity(0.1))
                .overlay {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 18).bold())
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                }
        }
        .buttonStyle(.plain)
    }
    
    private func dismissStockView() async {
        dismiss()
    }
    
    private func showSearch() async {
        isShowingSearch.toggle()
    }
}

struct StockTickerView_Previews: PreviewProvider {
    
    static var tradingStubsQuoteVM: TickerQuoteViewModel = {
       var mockAPI = MockStocksAPI()
        mockAPI.stubbedFetchQuotesCallback = {
            [Quote.stub(isTrading: true)]
        }
        return TickerQuoteViewModel(ticker: .stub, dataService: mockAPI)
    }()
    
    static var closedStubsQuoteVM: TickerQuoteViewModel = {
       var mockAPI = MockStocksAPI()
        mockAPI.stubbedFetchQuotesCallback = {
            [Quote.stub(isTrading: false)]
        }
        return TickerQuoteViewModel(ticker: .stub, dataService: mockAPI)
    }()
    
    
    static var loadingStubsQuoteVM: TickerQuoteViewModel = {
       var mockAPI = MockStocksAPI()
        mockAPI.stubbedFetchQuotesCallback = {
            await withCheckedContinuation { _ in
                
            }
        }
        return TickerQuoteViewModel(ticker: .stub, dataService: mockAPI)
    }()
    
    
    static var errorStubsQuoteVM: TickerQuoteViewModel = {
       var mockAPI = MockStocksAPI()
        mockAPI.stubbedFetchQuotesCallback = {
            throw NSError(domain: "error", code: 0, userInfo: [NSLocalizedDescriptionKey: "An error has been occured"])
        }
        return TickerQuoteViewModel(ticker: .stub, dataService: mockAPI)
    }()
    
    static var chartVM: ChartViewModel {
        ChartViewModel(ticker: .stub, dataService: MockStocksAPI())
    }
    
    @State static var isShowingSearch: Bool = false
    
    static var previews: some View {
        
        
        
        Group {
            StockTickerView(chartViewModel: chartVM, quoteViewModel: tradingStubsQuoteVM, isShowingSearch: $isShowingSearch)
                .previewDisplayName("Trading")
                .frame(height: 700)
            
            StockTickerView(chartViewModel: chartVM, quoteViewModel: closedStubsQuoteVM, isShowingSearch: $isShowingSearch)
                .previewDisplayName("Closed")
                .frame(height: 700)
            
            StockTickerView(chartViewModel: chartVM, quoteViewModel: loadingStubsQuoteVM, isShowingSearch: $isShowingSearch)
                .previewDisplayName("Loading Quote")
                .frame(height: 700)
            
            StockTickerView(chartViewModel: chartVM, quoteViewModel: errorStubsQuoteVM, isShowingSearch: $isShowingSearch)
                .previewDisplayName("Error Quote")
                .frame(height: 700)
            
        }.previewLayout(.sizeThatFits)
    }
}
