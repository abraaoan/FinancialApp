//
//  EmptyResultView.swift
//  FinancialApp
//
//  Created by Abraao Nascimento on 16/10/2023.
//

import SwiftUI

struct EmptyResultView: View {
    let message: String
    
    var body: some View {
        HStack {
            Spacer()
            Text(message)
                .font(.headline)
                .foregroundColor(Color(uiColor: .secondaryLabel))
            Spacer()
        }
        .padding(64)
        .lineLimit(3)
        .multilineTextAlignment(.center)
    }
}

struct EmptyResultView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyResultView(message: "OPS! Something went wrong")
    }
}
