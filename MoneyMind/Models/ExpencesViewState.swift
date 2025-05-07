//
//  ViewState.swift
//  MoneyMind
//
//  Created by Павел on 06.05.2025.
//

enum ViewState {
    case loading
    case content([MyModel])
    case error(String)
}
