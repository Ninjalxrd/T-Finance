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
        let label = DefaultElements.defaultTitleLabel()
        label.numberOfLines = 2
        label.text = "Введите сумму\nвашего дохода"
        return label
    }()
    
    lazy var budgetTextField: UITextField = {
        let textField = DefaultElements.defaultTextField()
        textField.placeholder = "Введите свой доход"
        textField.keyboardType = .numberPad
 
        return textField
    }()
    
    private lazy var nextScreenButton: UIButton = {
        let button = DefaultElements.defaultYellowButton(primaryAction: nextScreenAction)
        button.setTitle("Далее", for: .normal)
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
