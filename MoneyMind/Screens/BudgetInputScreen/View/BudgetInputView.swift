//
//  BudgetInputView.swift
//  MoneyMind
//
//  Created by Павел on 13.04.2025.
//

import UIKit
import SnapKit
import Combine

final class BudgetInputView: UIView {
    // MARK: - Publishers
    private let nextScreenSubject = PassthroughSubject<Void, Never>()
    var nextScreenPublisher: AnyPublisher<Void, Never> {
        nextScreenSubject.eraseToAnyPublisher()
    }
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Components
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .left
        label.font = Font.title.font
        label.textColor = .text
        label.text = "Введите сумму\nвашего дохода"
        return label
    }()
    
    lazy var budgetTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите свой доход"
        textField.font = Font.subtitle.font
        textField.layer.cornerRadius = Size.cornerRadius
        textField.backgroundColor = .component
        textField.keyboardType = .numberPad
        textField.returnKeyType = .next
        textField.clipsToBounds = true
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: Spacing.small, height: 0))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: Spacing.small, height: 0))
        textField.rightViewMode = .always
        
        return textField
    }()
    
    private lazy var nextScreenButton: UIButton = {
        let button = UIButton(primaryAction: nextScreenAction)
        button.setTitle("Далее", for: .normal)
        button.backgroundColor = .brand
        button.titleLabel?.font = Font.button.font
        button.tintColor = .text
        button.layer.cornerRadius = Size.cornerRadius
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var budgetInputStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, budgetTextField])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .leading
        stack.spacing = Spacing.small
        return stack
    }()
    
    private lazy var nextScreenAction = UIAction { [weak self] _ in
        self?.nextScreenSubject.send()
    }
    
    // MARK: - Public
    
    func setNextScreenButtonEnabled(_ isEnabled: Bool) {
        nextScreenButton.isEnabled = isEnabled
        nextScreenButton.alpha = isEnabled ? 1.0 : 0.5
    }
    
    // MARK: - Layout & Setup

    
    private func setupUI() {
        backgroundColor = .background
        addSubview(budgetInputStack)
        addSubview(nextScreenButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        budgetInputStack.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Spacing.large)
            make.leading.equalToSuperview().offset(Spacing.medium)
            make.trailing.equalToSuperview().offset(-Spacing.medium)
        }
        
        budgetTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Size.fieldHeight)
        }
        
        nextScreenButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Spacing.medium)
            make.trailing.equalToSuperview().offset(-Spacing.medium)
            make.bottom.equalTo(keyboardLayoutGuide.snp.top).offset(-Spacing.medium)
            make.height.equalTo(Size.buttonHeight)
        }
    }
}

// MARK: - Extension UITextField

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification)
            .compactMap { $0.object as? UITextField }
            .map { $0.text ?? "" }
            .eraseToAnyPublisher()
    }
}
