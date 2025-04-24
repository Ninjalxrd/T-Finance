//
//  EnterNumberView.swift
//  MoneyMind
//
//  Created by Павел on 23.04.2025.
//

import UIKit
import Combine
import SnapKit

final class EnterNumberView: UIView {
    // MARK: - Properties
    private let nextScreenSubject = PassthroughSubject<Void, Never>()
    var nextScreenPublisher: AnyPublisher<Void, Never> {
        nextScreenSubject.eraseToAnyPublisher()
    }
    private var cancellables = Set<AnyCancellable>()
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

    lazy var logoStack: UIStackView = {
        let stack = Logo().logoStackView
        return stack
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.title.font
        label.textColor = .text
        label.numberOfLines = 2
        label.text = "Введите номер\nтелефона"
        return label
    }()
    
    lazy var numberTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Номер телефона"
        textField.font = Font.subtitle.font
        textField.layer.cornerRadius = Size.cornerRadius
        textField.backgroundColor = .component
        textField.keyboardType = .numberPad
        textField.returnKeyType = .next
        textField.clipsToBounds = true
        textField.heightAnchor.constraint(equalToConstant: Size.fieldHeight).isActive = true
        
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
        button.heightAnchor.constraint(equalToConstant: Size.buttonHeight).isActive = true
        return button
    }()
    
    lazy var enterNumberStack: UIStackView = {
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
        numberTextField.bounds.contains(touch.location(in: numberTextField)) ? false : true    
    }
}

private extension CGFloat {
    static let logoStackHeight: CGFloat = 64
    static let bottomBorderImageHeight: CGFloat = 237
}
