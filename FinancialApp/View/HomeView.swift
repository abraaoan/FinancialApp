//
//  HomeView.swift
//  FinancialApp
//
//  Created by Abraao Nascimento on 16/10/2023.
//

import SwiftUI

struct HomeView: View {
    @State var isShowingSearch: Bool = false
    @StateObject var searchViewModel = SearchViewModel()
    
    var body: some View {
        NavigationView {
            emptyView
        }.sheet(isPresented: $isShowingSearch) {
            SearchView(viewModel: searchViewModel)
        }.sheet(item: $searchViewModel.selectedTicker) { ticket in
            StockTickerView(chartViewModel: ChartViewModel(ticker: ticket,
                                                           dataService: searchViewModel.dataService),
                            quoteViewModel: .init(ticker: ticket, dataService: searchViewModel.dataService),
                            isShowingSearch: $isShowingSearch)
            .presentationDetents([.height(560)])
        }
    }
    
    var emptyView: some View {
        VStack {
            Text("Welcome to Stock App Challenge")
            Button("Start here") {
                isShowingSearch.toggle()
            }
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .font(.system(size: 17, weight: .bold))
            .cornerRadius(10)
            .padding(.top)
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
