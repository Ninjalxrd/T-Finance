//
//  AddGoalView.swift
//  MoneyMind
//
//  Created by Павел on 06.06.2025.
//

import UIKit
import Combine
import SnapKit

class AddGoalView: UIView {
    // MARK: - Published Properties
    
    private let deadlineSubject = PassthroughSubject<Void, Never>()
    var deadlinePublisher: AnyPublisher<Void, Never> {
        deadlineSubject.eraseToAnyPublisher()
    }
    
    private let addSubject = PassthroughSubject<Void, Never>()
    var addPublisher: AnyPublisher<Void, Never> {
        addSubject.eraseToAnyPublisher()
    }
    
    var namePublisher: AnyPublisher<String, Never> {
        nameTextField.textChangedPublisher
    }

    var descriptionPublisher: AnyPublisher<String, Never> {
        descriptionTextField.textChangedPublisher
    }

    var amountPublisher: AnyPublisher<String, Never> {
        amountTextField.textChangedPublisher
    }

    // MARK: - Properties
    
    private let mode: GoalViewMode
    
    // MARK: - Init
    
    init(mode: GoalViewMode) {
        self.mode = mode
        super.init(frame: .zero)
        setupTitle()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements
    
    private lazy var titleLabel: UILabel = {
        let label = DefaultTitleLabel(numberOfLines: 2, text: "")
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = DefaultTextField(
            placeholder: "Название",
            textAlignment: .left,
            keyboardType: .default)
        textField.heightAnchor.constraint(equalToConstant: CGFloat.componentsHeight).isActive = true
        return textField
    }()
    
    private lazy var descriptionTextField: UITextField = {
        let textField = DefaultTextField(
            placeholder: "Описание",
            textAlignment: .left,
            keyboardType: .default)
        textField.heightAnchor.constraint(equalToConstant: CGFloat.componentsHeight).isActive = true
        return textField
    }()
    
    private lazy var amountTextField: UITextField = {
        let textField = DefaultTextField(
            placeholder: "Сумма",
            textAlignment: .left,
            keyboardType: .default)
        textField.keyboardType = .decimalPad
        textField.delegate = self
        textField.heightAnchor.constraint(equalToConstant: CGFloat.componentsHeight).isActive = true
        return textField
    }()
    
    private lazy var deadlineButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.title = "Срок"
        configuration.titleAlignment = .leading
        let attributedString = NSAttributedString(
            string: "Срок",
            attributes: [
                .font: Font.subtitle.font,
                .foregroundColor: UIColor.secondaryText
            ]
        )
        configuration.attributedTitle = AttributedString(attributedString)
        configuration.image = UIImage(systemName: "chevron.down")?
            .withRenderingMode(.alwaysTemplate)
        configuration.imagePlacement = .trailing
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: Spacing.medium,
            bottom: 0,
            trailing: Spacing.medium
        )
        let button = UIButton(configuration: configuration, primaryAction: deadlineButtonAction)
        button.contentHorizontalAlignment = .fill
        button.tintColor = .secondaryText
        button.backgroundColor = .component
        button.layer.cornerRadius = Size.cornerRadius
        button.heightAnchor.constraint(equalToConstant: CGFloat.componentsHeight).isActive = true
        return button
    }()
    
    // MARK: - Setters
    
    func setDeadlineTitle(_ string: String?) {
        let title = string ?? "Срок"
        deadlineButton.setTitle("до \(title)", for: .normal)
        if string != nil {
            deadlineButton.setTitleColor(.text, for: .normal)
        } else {
            deadlineButton.setTitleColor(.placeholderText, for: .normal)
        }
    }
    
    func setSaveButtonEnabled(_ isEnabled: Bool) {
        saveButton.isEnabled = isEnabled
        saveButton.alpha = isEnabled ? 1.0 : 0.5
    }

    private lazy var deadlineButtonAction = UIAction { [weak self] _ in
        self?.deadlineSubject.send()
    }
    
    private lazy var saveButton: UIButton = {
        let button = DefaultButton(title: "Сохранить", action: saveButtonAction)
        button.heightAnchor.constraint(equalToConstant: Size.buttonHeight).isActive = true
        return button
    }()
    
    private lazy var saveButtonAction = UIAction { [weak self] _ in
        self?.endEditing(true)
        self?.addSubject.send()
    }
    
    private lazy var newGoalStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            nameTextField,
            descriptionTextField,
            amountTextField,
            deadlineButton
        ])
        stack.axis = .vertical
        stack.spacing = Spacing.medium
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        return stack
    }()
    
    // MARK: - Setup UI
    
    private func setupUI() {
        backgroundColor = .background
        addSubview(newGoalStackView)
        addSubview(saveButton)
        setupConstaints()
    }
    
    private func setupConstaints() {
        newGoalStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Spacing.small)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Spacing.medium)
        }
        
        saveButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Spacing.small)
            make.bottom.equalTo(keyboardLayoutGuide.snp.top).offset(-Spacing.medium)
        }
    }
    
    private func setupTitle() {
        switch mode {
        case .create:
            titleLabel.text = "Создание\nцели"
        case .edit:
            titleLabel.text = "Редактирование\nцели"
        }
    }
}

extension AddGoalView: UITextFieldDelegate {
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

private extension CGFloat {
    static let componentsHeight: CGFloat = 56
}
