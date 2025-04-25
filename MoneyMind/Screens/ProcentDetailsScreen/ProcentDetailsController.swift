//
//  ProcentDetailsController.swift
//  MoneyMind
//
//  Created by Павел on 18.04.2025.
//

import UIKit
import Combine
import SnapKit

final class ProcentDetailsController: UIViewController {
    // MARK: - Properties
    
    private let selectedCategory: Category
    private let procentsView: ProcentDetailsView = .init()
    private let procentsViewModel: ProcentDetailsViewModel
    private var cancellables = Set<AnyCancellable>()
    private var budget: Int
    let onAddCategory = PassthroughSubject<Category, Never>()
    
    // MARK: - Lifecycle
    init(budget: Int, remainingPercent: Int, selectedCategory: Category) {
        self.selectedCategory = selectedCategory
        self.budget = budget
        self.procentsViewModel = ProcentDetailsViewModel(
            remainingValue: budget,
            remainingPercent: remainingPercent
        )
        procentsView.setupTitleLabel(with: selectedCategory)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = procentsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        setupCallbacks()
        bindTextField()
        bindViewModel()
        addObserver()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup & Binds
    private func setupDelegates() {
        procentsView.procentsTextField.delegate = self
    }

    private func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillChange),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }
    
    private func setupCallbacks() {
        procentsView.dismissButtonPublisher
            .sink { [weak self] in
                self?.dismiss(animated: true)
            }
            .store(in: &cancellables)
        
        procentsView.addCategoryPublisher
            .sink { [weak self] in
                guard let self else { return }
                guard let text = procentsView.procentsTextField.text,
                let percent = Int(text)
                else { return }
                
                var updatedCategory = selectedCategory
                updatedCategory.percent = percent
                updatedCategory.money = procentsViewModel.moneyValue
                updatedCategory.isPicked = true
                
                onAddCategory.send(updatedCategory)
                self.dismiss(animated: true)
            }
            .store(in: &cancellables)
    }
    
    private func bindTextField() {
        procentsView.procentsTextField
            .textPublisher
            .map { Int($0) ?? 0 }
            .sink { [weak self] value in
                guard let self else { return }
                procentsViewModel.updateValues(value: value)
            }
            .store(in: &cancellables)
    }
    
    private func bindViewModel() {
        procentsViewModel.$moneyValue
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self else { return }
                procentsView.procentSumLabel.text = "\(value) ₽"
            }
            .store(in: &cancellables)
        
        procentsViewModel.$remainingValue
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self else { return }
                procentsView.balanceLabel.text = "\(value) ₽"
            }
            .store(in: &cancellables)
        
        procentsViewModel.$remainingPercent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self else { return }
                procentsView.procentsBalanceLabel.text = "Всего процентов осталось: \(value)%"
            }
            .store(in: &cancellables)
    }
    
    func setupModalStyle(
        _ presentationStyle: UIModalPresentationStyle,
        _ transitionStyle: UIModalTransitionStyle
    ) {
        self.modalTransitionStyle = transitionStyle
        self.modalPresentationStyle = presentationStyle
    }
    
    // MARK: - Keyboard
    
    @objc private func handleKeyboardWillChange(notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }

        let keyboardHeight = view.convert(endFrame, from: nil).intersection(view.bounds).height

        procentsView.bottomConstraint?.update(offset: -keyboardHeight)

        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: UIView.AnimationOptions(rawValue: curveValue << 16),
            animations: { self.view.layoutIfNeeded() },
            completion: nil
        )
    }
}

// MARK: - UITextFieldDelegate

extension ProcentDetailsController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        let isNumeric = updatedText.allSatisfy { $0.isNumber }
        if updatedText.isEmpty {
            return true
        }
        let number = Int(updatedText) ?? 0
        
        return isNumeric && number >= 1 && number <= procentsViewModel.remainingPercentLimit
    }
}
