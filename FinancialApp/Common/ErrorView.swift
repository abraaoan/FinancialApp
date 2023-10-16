//
//  ErrorView.swift
//  FinancialApp
//
//  Created by Abraao Nascimento on 16/10/2023.
//

import SwiftUI

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

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error: "ERROR :/")
    }
}
