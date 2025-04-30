//
//  EnterNumberView.swift
//  MoneyMind
//
//  Created by Павел on 23.04.2025.
//

import UIKit
import Combine
import SnapKit
import PhoneNumberKit

final class EnterNumberView: UIView {
    // MARK: - Properties
    private let nextScreenSubject = PassthroughSubject<Void, Never>()
    var nextScreenPublisher: AnyPublisher<Void, Never> {
        nextScreenSubject.eraseToAnyPublisher()
    }
    private var bag: Set<AnyCancellable> = []
    var bottomConstraint: Constraint?
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Components

    private(set) lazy var logoStack = Logo()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.title.font
        label.textColor = .text
        label.numberOfLines = 2
        label.text = "Введите номер\nтелефона"
        return label
    }()
    
    private lazy var numberTextField: RussianPhoneNumberTextField = {
        let textField = RussianPhoneNumberTextField()
        
        textField.textAlignment = .left
        textField.keyboardType = .numberPad
        textField.backgroundColor = .component
        textField.autocorrectionType = .no
        textField.font = Font.subtitle.font
        textField.layer.cornerRadius = Size.cornerRadius
        textField.backgroundColor = .component
        textField.clipsToBounds = true
        textField.withPrefix = true
        textField.withExamplePlaceholder = true
        textField.withDefaultPickerUI = false
        textField.textColor = .text
        
        textField.delegate = self
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: Spacing.medium, height: 0))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: Spacing.medium, height: 0))
        textField.rightViewMode = .always
        textField.heightAnchor.constraint(equalToConstant: Size.fieldHeight).isActive = true

        return textField
    }()
    
    // MARK: - Number Getter
    
    func getNumber() -> String {
        return numberTextField.text ?? ""
    }
    
    // MARK: - Internal NumberTextField Methods
    
    func setTextFieldDelegate(_ delegate: UITextFieldDelegate) {
        numberTextField.delegate = delegate
    }
    
    // MARK: - Internal Accessor

    var numberTextFieldPublisher: AnyPublisher<String, Never> {
        numberTextField.textPublisher
    }
        
    private lazy var nextScreenButton: UIButton = {
        let button = DefaultButton(title: "Далее", action: nextScreenAction)
        button.heightAnchor.constraint(equalToConstant: Size.buttonHeight).isActive = true
        return button
    }()
    
    private lazy var enterNumberStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, numberTextField, nextScreenButton])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = Spacing.small
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var bottomBorderImage: UIImageView = {
        let image = UIImageView()
        image.image = .authBottomEdge
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var nextScreenAction = UIAction { [weak self] _ in
        self?.nextScreenSubject.send()
    }
    
    // MARK: - Public Methods
    
    func isInputValid(_ isValid: Bool) {
        nextScreenButton.isEnabled = isValid
        nextScreenButton.alpha = isValid ? 1 : 0.5
    }
    
    // MARK: - UIGestureRecognizers
    
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.delegate = self
        tap.cancelsTouchesInView = false
        return tap
    }()

    @objc func tapAction() {
        self.endEditing(true)
    }
    
    private lazy var downSwipeGestureRecognizer: UISwipeGestureRecognizer = {
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(downSwipeAction))
        swipeRecognizer.direction = .down
        swipeRecognizer.delegate = self
        swipeRecognizer.cancelsTouchesInView = false
        return swipeRecognizer
    }()
    
    @objc func downSwipeAction() {
        self.endEditing(true)
    }
    
    // MARK: - Setup UI Methods
    
    private func setupUI() {
        backgroundColor = .background
        addSubview(logoStack)
        addSubview(enterNumberStack)
        addSubview(bottomBorderImage)
        addGestureRecognizers()
        setupConstraints()
    }
    
    private func addGestureRecognizers() {
        addGestureRecognizer(tapGestureRecognizer)
        addGestureRecognizer(downSwipeGestureRecognizer)
    }
    
    private func setupConstraints() {
        logoStack.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Spacing.large)
            make.centerX.equalToSuperview()
            make.height.equalTo(CGFloat.logoStackHeight)
        }
        
        enterNumberStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Spacing.large)
            make.trailing.equalToSuperview().offset(-Spacing.large)
            bottomConstraint = make.bottom.equalTo(bottomBorderImage.snp.top).offset(-Spacing.large)
                .constraint
        }
        
        bottomBorderImage.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(Spacing.medium)
            make.height.equalTo(CGFloat.bottomBorderImageHeight)
        }
    }
}

    // MARK: - UIGestureRecognizerDelegate
extension EnterNumberView:
    UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        numberTextField.bounds.contains(touch.location(in: numberTextField))
        || nextScreenButton.bounds.contains(touch.location(in: nextScreenButton))
        ? false : true    
    }
}

private extension CGFloat {
    static let logoStackHeight: CGFloat = 64
    static let bottomBorderImageHeight: CGFloat = 237
}

extension EnterNumberView: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard
            let currentText = textField.text,
            let textRange = Range(range, in: currentText)
        else {
            return false
        }
        let updatedText = currentText.replacingCharacters(in: textRange, with: string)
        if updatedText.count < 2 || !updatedText.hasPrefix("+7") {
            return false
        }
        let currentDigits = updatedText.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        if string.isEmpty {
            return true
        }
        if currentDigits.count > 11 {
            return false
        }
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string))
    }
}
