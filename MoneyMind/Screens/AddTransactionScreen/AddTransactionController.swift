//
//  AddTransactionController.swift
//  MoneyMind
//
//  Created by Павел on 26.04.2025.
//

import UIKit
import Combine

final class AddTransactionController: UIViewController {
    private let viewModel: AddTransactionViewModel
    private let addTransactionView = AddTransactionView()
    private var bag: Set<AnyCancellable> = []
    
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
        setupCallbacks()
    }
    
    private func setupCallbacks() {
        addTransactionView
            .categoryPublisher
            .sink { [weak self] _ in
                self?.viewModel.openCategoriesScreen()
            }
            .store(in: &bag)
    }
}
