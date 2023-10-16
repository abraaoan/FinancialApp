//
//  HomeView.swift
//  FinancialApp
//
//  Created by Abraao Nascimento on 16/10/2023.
//

import SwiftUI

struct HomeView: View {
    
    @State var isShowingSearch: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                
                // Initial state
                Text("Welcome to Stock App Challenge")
                
                // Search button
                Button("Search an entity") {
                    isShowingSearch.toggle()
                }
                .padding()
                .background(.blue)
                .foregroundColor(.white)
                .font(.system(size: 17, weight: .bold))
                .cornerRadius(10)
                .padding(.top)
                
            }
        }.sheet(isPresented: $isShowingSearch) {
            SearchView(viewModel: SearchViewModel())
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
