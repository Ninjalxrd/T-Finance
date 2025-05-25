//
//  GoalsViewState.swift
//  MoneyMind
//
//  Created by Павел on 16.05.2025.
//

enum GoalsViewState {
    case loading
    case content([Goal])
    case error(String)
}
