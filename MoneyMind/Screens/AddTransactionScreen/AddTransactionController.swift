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
        bindViewModel()
    }
    
    private func setupCallbacks() {
        addTransactionView
            .categoryPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.openCategoriesScreen()
            }
            .store(in: &bag)

        addTransactionView
            .otherDayPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.openDatePicker()
            }
            .store(in: &bag)
        
        addTransactionView.daySubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] date in
                self?.viewModel.dateSubject.send(date)
            }
            .store(in: &bag)
        
        addTransactionView.getAmountTextField()
            .textChangedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.viewModel.amount = text
            }
            .store(in: &bag)
        
        addTransactionView
            .addPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.addNewTransaction()
            }
            .store(in: &bag)

        addTransactionView.setupTextFieldDelegate(self)
    }
    
    private func bindViewModel() {
        viewModel.categorySubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] category in
                self?.addTransactionView.setCategoryTitle(category?.name)
            }
            .store(in: &bag)
        viewModel.isFormValidPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] bool in
                self?.addTransactionView.setNextScreenButtonEnabled(bool)
            }
            .store(in: &bag)
        viewModel.$amount
            .receive(on: DispatchQueue.main)
            .sink { [weak self] amount in
                self?.addTransactionView.setAmountText(amount)
            }
            .store(in: &bag)
    }
}

extension AddTransactionController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        let isNumeric = updatedText.allSatisfy { $0.isNumber }
        return isNumeric
    }
}

extension UITextField {
    var textChangedPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { ($0.object as? UITextField)?.text }
            .eraseToAnyPublisher()
    }
}

