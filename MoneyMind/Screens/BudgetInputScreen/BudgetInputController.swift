//
//  BudgetInputController.swift
//  MoneyMind
//
//  Created by Павел on 12.04.2025.
//

import UIKit
import SnapKit
import Combine

final class BudgetInputController: UIViewController {    
    private let budgetInputView: BudgetInputView = .init()
    private let viewModel: BudgetInputViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: BudgetInputViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = budgetInputView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupCallback()
    }
    
    private func bindViewModel() {        
        budgetInputView.budgetTextField.textPublisher
            .assign(
                to: \.incomeText,
                on: viewModel)
            .store(in: &cancellables)
        
        viewModel.isInputValid
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                self?.budgetInputView.setNextScreenButtonEnabled(isValid)
            }
            .store(in: &cancellables)
    }
    
    private func setupCallback() {
        budgetInputView.nextScreenPublisher
            .sink { [weak self] in
                guard
                    let self,
                    let text = self.budgetInputView.budgetTextField.text,
                    let budget = Int(text)
                else { return }
                self.viewModel.nextScreenButtonTapped(with: budget)
            }
            .store(in: &cancellables)
    }
}
