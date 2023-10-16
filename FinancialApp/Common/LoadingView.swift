//
//  LoadingView.swift
//  FinancialApp
//
//  Created by Abraao Nascimento on 16/10/2023.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        HStack {
            Spacer()
            ProgressView()
                .progressViewStyle(.circular)
            Spacer()
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
