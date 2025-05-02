//
//  AddTransactionController.swift
//  MoneyMind
//
//  Created by Павел on 26.04.2025.
//

import UIKit

final class AddTransactionController: UIViewController {
    private let viewModel: AddTransactionViewModel
    private let addTransactionView: AddTransactionView = .init(frame: .zero)
    
    init(viewModel: AddTransactionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = addTransactionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
