//
//  ConfirmationView.swift
//  MoneyMind
//
//  Created by Павел on 24.04.2025.
//

import UIKit
import Combine

final class ConfirmationView: UIView {
    // MARK: - Properties
    
    private let newCodeSubject = PassthroughSubject<Void, Never>()
    var newCodePublisher: AnyPublisher<Void, Never> {
        newCodeSubject.eraseToAnyPublisher()
    }
    private var cancellables = Set<AnyCancellable>()
    
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
        let label = DefaultLabel(numberOfLines: 1, text: "Подтверждение")
        return label
    }()
    
    private lazy var codeSentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = Font.subtitle.font
        label.textColor = .text
        label.heightAnchor.constraint(equalToConstant: CGFloat.codeSentLabelHeight).isActive = true
        label.widthAnchor.constraint(equalToConstant: CGFloat.codeSentLabelWidth).isActive = true
        return label
    }()
    
    private lazy var codeTextField: UITextField = {
        let textField = DefaultTextField(
            placeholder: "СМС-код",
            textAlignment: .center,
            keyboardType: .numberPad
        )
        textField.widthAnchor.constraint(equalToConstant: CGFloat.codeStackWidth).isActive = true
        return textField
    }()
    
    // MARK: - Internal TextField Methods
    
    func setupTextFieldDelegate(_ delegate: UITextFieldDelegate) {
        codeTextField.delegate = delegate
    }
        
    private lazy var newCodeButton: UIButton = {
        let button = DefaultButton(title: "Отправить код заново", action: newCodeAction)
        button.backgroundColor = .secondaryButton
        button.heightAnchor.constraint(equalToConstant: Size.buttonHeight).isActive = true
        button.widthAnchor.constraint(equalToConstant: CGFloat.codeStackWidth).isActive = true
        return button
    }()
    
    // MARK: - Internal Button Methods

    func toggleHideNewCodeButton(_ bool: Bool) {
        newCodeButton.isHidden = bool
    }
    
    // MARK: - Actions
    
    private lazy var newCodeAction = UIAction { [weak self] _ in
        self?.newCodeSubject.send()
    }
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.font = Font.subtitle.font
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .text
        label.heightAnchor.constraint(equalToConstant: CGFloat.timelLabelHeight).isActive = true
        label.isHidden = true
        return label
    }()
    
    // MARK: - Internal TimerLabel methods
    
    func setupTimerLabelText(_ text: String) {
        timerLabel.text = text
    }
    
    func toggleHideTimerLabel(_ bool: Bool) {
        timerLabel.isHidden = bool
    }
    
    // MARK: - Stack
    
    private lazy var codeStackView: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [
                codeSentLabel,
                codeTextField,
                newCodeButton
            ])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = Spacing.small
        return stack
    }()
    
    // MARK: - Layout & Setup

    private func setupUI() {
        backgroundColor = .background
        addSubview(titleLabel)
        addSubview(codeStackView)
        addSubview(timerLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(CGFloat.titleLabelOffset)
            make.leading.trailing.equalToSuperview().offset(Spacing.medium)
            make.height.equalTo(CGFloat.titleLabelHeight)
        }
        
        codeStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(CGFloat.codeStackOffset)
            make.centerX.equalToSuperview()
        }
        
        timerLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(newCodeButton)
        }
    }
    
    func configureLabel(with number: String) {
        codeSentLabel.text = "Код отправлен на номер \n \(number)"
    }
}

private extension CGFloat {
    static let titleLabelOffset: CGFloat = 96
    static let codeStackOffset: CGFloat = 96
    static let codeStackWidth: CGFloat = 216
    static let codeSentLabelHeight: CGFloat = 50
    static let codeSentLabelWidth: CGFloat = 200
    static let titleLabelHeight: CGFloat = 43
    static let timelLabelHeight: CGFloat = 19
}
