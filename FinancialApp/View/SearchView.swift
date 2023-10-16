//
//  SearchView.swift
//  FinancialApp
//
//  Created by Abraao Nascimento on 16/10/2023.
//

import SwiftUI
import XCAStocksAPI

struct SearchView<SearchViewModelObservable>: View where SearchViewModelObservable: SearchViewModelProtocol {
    @Environment(\.dismiss) var dismiss
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
        case .empty: emptyView
        case .failure(let error):
            ErrorView(error: error.localizedDescription) {
                Task { await viewModel.searchTickers() }
            }
        case .loading: loadingView
        default: EmptyView()
        }
    }
    
    private var emptyView: some View {
        HStack {
            Spacer()
            Text(viewModel.emptyListText)
                .font(.headline)
                .foregroundColor(Color(uiColor: .secondaryLabel))
            Spacer()
        }
        .padding(64)
        .lineLimit(3)
        .multilineTextAlignment(.center)
    }
    
    private var loadingView: some View {
        HStack {
            Spacer()
            ProgressView()
                .progressViewStyle(.circular)
            Spacer()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static let viewModel = SearchViewModel()
    static var previews: some View {
        SearchView(viewModel: viewModel)
    }
}

struct ErrorView: View {
    let error: String
    var retryHandler: (() -> ())? = nil
    
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 16) {
                Text(error)
                if let retryHandler {
                    Button("Try again", action: retryHandler)
                        .buttonStyle(.borderedProminent)
                }
                
            }
            Spacer()
        }
        .padding(64)
    }
}
