//
//  ExpencesViewState.swift
//  MoneyMind
//
//  Created by Павел on 06.05.2025.
//

enum ExpencesViewState {
    case loading
    case content([Expence])
    case error(String)
}
