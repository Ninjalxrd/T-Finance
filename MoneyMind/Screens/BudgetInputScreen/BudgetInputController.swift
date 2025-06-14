//  BudgetInputController.swift
//  MoneyMind
//
//  Created by Павел on 12.04.2025.
//

import UIKit
import SnapKit
import Combine

final class BudgetInputController: UIViewController {
    // MARK: Properties
    private let budgetInputView: BudgetInputView = .init()
    private let viewModel: BudgetInputViewModel
    private var bag = Set<AnyCancellable>()

    // MARK: Init
    init(viewModel: BudgetInputViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Lifecycle
    
    override func loadView() { view = budgetInputView }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupCallback()
        setupNavigationBar()
    }

    // MARK: - Binding
    
    private func bindViewModel() {
        budgetInputView.budgetTextFieldPublisher
            .assign(to: \.incomeText, on: viewModel)
            .store(in: &bag)

        viewModel.isInputValid
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.budgetInputView.setNextScreenButtonEnabled($0)
            }
            .store(in: &bag)
    }

    // MARK: - Callbacks
    
    private func setupCallback() {
        budgetInputView.nextScreenPublisher
            .sink { [weak self] in
                guard
                    let self,
                    let text = self.budgetInputView.getBudget(),
                    let budget = Int(text) else { return }
                self.viewModel.nextScreenButtonTapped(with: budget)
            }
            .store(in: &bag)
    }
    
    private func setupNavigationBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
