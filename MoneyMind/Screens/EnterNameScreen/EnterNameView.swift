//
//  EnterNameView.swift
//  MoneyMind
//
//  Created by Павел on 25.04.2025.
//

import UIKit
import Combine

final class EnterNameView: UIView {
    // MARK: - Publishers
    
    private let nextScreenSubject = PassthroughSubject<Void, Never>()
    var nextScreenPublisher: AnyPublisher<Void, Never> {
        nextScreenSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Properties
    
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
        let label = DefaultLabel(numberOfLines: 1, text: "Введите ваше имя")
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = DefaultTextField(
            placeholder: "Ваше имя",
            textAlignment: .left,
            keyboardType: .namePhonePad
        )
        textField.widthAnchor.constraint(equalToConstant: CGFloat.nameStackWidth).isActive = true
        return textField
    }()
    
    private lazy var nextScreenButton: UIButton = {
        let button = DefaultButton(title: "Далее", action: action)
        button.heightAnchor.constraint(equalToConstant: Size.buttonHeight).isActive = true
        button.widthAnchor.constraint(equalToConstant: CGFloat.nameStackWidth).isActive = true
        return button
    }()
    
    private lazy var nameStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameTextField, nextScreenButton])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 5
        return stack
    }()
    
    private lazy var action = UIAction { [weak self] _ in
        self?.nextScreenSubject.send()
    }
    
    // MARK: - Setup UI

    private func setupUI() {
        backgroundColor = .background
        addSubview(titleLabel)
        addSubview(nameStackView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(CGFloat.titleLabelOffset)
            make.leading.trailing.equalToSuperview().offset(Spacing.medium)
            make.height.equalTo(CGFloat.titleLabelHeight)
        }
        
        nameStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(CGFloat.nameStackOffset)
            make.centerX.equalToSuperview()
        }
    }
}

private extension CGFloat {
    static let titleLabelOffset: CGFloat = 96
    static let nameStackOffset: CGFloat = 96
    static let titleLabelHeight: CGFloat = 43
    static let nameStackWidth: CGFloat = 319
}
