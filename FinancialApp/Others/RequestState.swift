//
//  RequestState.swift
//  FinancialApp
//
//  Created by Abraao Nascimento on 16/10/2023.
//

enum RequestState {
    case initial
    case empty
    case failure(Error)
    case loading
    case success
}

