//
//  ProcentDetailsView.swift
//  MoneyMind
//
//  Created by Павел on 18.04.2025.
//

import UIKit
import Combine
import SnapKit

final class ProcentDetailsView: UIView {
    // MARK: - Publishers
    private let addCategorySubject = PassthroughSubject<Void, Never>()
    var addCategoryPublisher: AnyPublisher<Void, Never> {
        return addCategorySubject.eraseToAnyPublisher()
    }
    private let dismissButtonSubject = PassthroughSubject<Void, Never>()
    var dismissButtonPublisher: AnyPublisher<Void, Never> {
        return dismissButtonSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Properties

    var bottomConstraint: Constraint?
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        view.layer.cornerRadius = Size.cornerRadius
        return view
    }()
    
    private lazy var handleDismissButton: UIButton = {
        let button = UIButton(primaryAction: dismissAction) 
        button.setImage(UIImage(named: "handle"), for: .normal)
        button.tintColor = .secondaryText
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .left
        label.font = Font.smallTitle.font
        label.textColor = .text
        return label
    }()
    
    private lazy var enterProcentsView: UIView = {
        let view = UIView()
        view.backgroundColor = .component
        view.layer.cornerRadius = Size.cornerRadius
        view.clipsToBounds = true
        view.heightAnchor.constraint(equalToConstant: Size.fieldHeight).isActive = true
        return view
    }()
    
    private lazy var enterProcentsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, enterProcentsView])
        stack.axis = .vertical
        stack.spacing = Spacing.medium
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    lazy var procentsTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "%"
        textField.backgroundColor = .clear
        textField.textAlignment = .center
        textField.textColor = .text
        textField.keyboardType = .numberPad
        textField.becomeFirstResponder()
        return textField
    }()

    
    lazy var procentsBalanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryText
        label.font = Font.subtitle.font
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private func setupProcentsView() {
        enterProcentsView.addSubview(procentsTextField)
        enterProcentsView.addSubview(procentsBalanceLabel)
        
        procentsTextField.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(Spacing.small)
            make.bottom.equalToSuperview().offset(-Spacing.small)
            make.width.equalTo(CGFloat.textFieldWidth)
        }
        
        procentsBalanceLabel.snp.makeConstraints { make in
            make.leading.equalTo(procentsTextField.snp.trailing).offset(Spacing.small)
            make.top.equalToSuperview().offset(Spacing.small)
            make.trailing.equalToSuperview().offset(-Spacing.small)
            make.bottom.equalToSuperview().offset(-Spacing.small)
        }
    }

    private lazy var thisLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = Font.subtitle.font
        label.textColor = .secondaryText
        label.text = "Это"
        return label
    }()
    
    private lazy var remainderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .right
        label.font = Font.subtitle.font
        label.textColor = .secondaryText
        label.text = "Остается"
        return label
    }()
    
    lazy var procentSumLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = Font.subtitle.font
        label.textColor = .text
        label.heightAnchor.constraint(equalToConstant: CGFloat.labelHeight).isActive = true
        return label
    }()
    
    lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = Font.subtitle.font
        label.textColor = .text
        label.heightAnchor.constraint(equalToConstant: CGFloat.labelHeight).isActive = true
        return label
    }()
    
    private lazy var separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondaryText
        view.heightAnchor.constraint(equalToConstant: CGFloat.separatorHeight).isActive = true
        view.widthAnchor.constraint(equalToConstant: CGFloat.separatorWidth).isActive = true
        return view
    }()
    
    private lazy var balanceStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [procentSumLabel, separator, balanceLabel])
        stack.axis = .horizontal
        stack.spacing = Spacing.small
        stack.alignment = .center
        stack.distribution = .equalCentering
        return stack
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(primaryAction: addCategoryAction)
        button.setTitle("Добавить", for: .normal)
        button.backgroundColor = .brand
        button.titleLabel?.font = Font.button.font
        button.tintColor = .text
        button.layer.cornerRadius = Size.cornerRadius
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var addCategoryAction = UIAction { [weak self] _ in
        self?.addCategorySubject.send()
    }

    private lazy var dismissAction = UIAction { [weak self] _ in
        self?.dismissButtonSubject.send()
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.delegate = self
        tap.cancelsTouchesInView = false
        return tap
    }()

    @objc func tapAction() {
        self.endEditing(true)
    }
    
    private func setupUI() {
        backgroundColor = .background
        addSubview(contentView)
        contentView.addSubview(handleDismissButton)
        contentView.addSubview(enterProcentsStack)
        contentView.addSubview(thisLabel)
        contentView.addSubview(remainderLabel)
        contentView.addSubview(balanceStack)
        contentView.addSubview(addButton)
        addGestureRecognizer(tapGestureRecognizer)
        setupProcentsView()
        setupConstraints()
    }
    
    private func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            bottomConstraint = make.bottom.equalToSuperview().constraint
            make.height.equalTo(CGFloat.contentViewScale)
        }
        
        handleDismissButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Spacing.small)
            make.centerX.equalToSuperview()
            make.width.equalTo(CGFloat.handleDismissWidth)
            make.height.equalTo(CGFloat.handleDismissHeight)
        }
        
        enterProcentsStack.snp.makeConstraints { make in
            make.bottom.equalTo(thisLabel.snp.top).offset(-Spacing.large)
            make.leading.equalToSuperview().offset(Spacing.medium)
            make.trailing.equalToSuperview().offset(-Spacing.medium)
        }
        
        thisLabel.snp.makeConstraints { make in
            make.leading.equalTo(enterProcentsStack.snp.leading)
            make.bottom.equalTo(balanceStack.snp.top).offset(-Spacing.medium)
            make.width.equalTo(CGFloat.labelWidth)
        }
        
        remainderLabel.snp.makeConstraints { make in
            make.trailing.equalTo(enterProcentsStack.snp.trailing)
            make.bottom.equalTo(balanceStack.snp.top).offset(-Spacing.medium)
            make.width.equalTo(CGFloat.remainderLabelWidth)
        }
        
        balanceStack.snp.makeConstraints { make in
            make.leading.trailing.equalTo(enterProcentsStack)
            make.bottom.equalTo(addButton.snp.top).offset(-Spacing.large)
        }
        
        separator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }
        
        addButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(enterProcentsStack)
            make.bottom.equalToSuperview().offset(-Spacing.medium)
            make.height.equalTo(Size.buttonHeight)
        }
    }
    
    func setupTitleLabel(with category: Category) {
        titleLabel.text = "Укажите процент категории:\n\(category.name)"
    }
}

// MARK: - UIGestureRecognizerDelegate
extension ProcentDetailsView:
    UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
    
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch
    ) -> Bool {
        if addButton.bounds.contains(touch.location(in: addButton))
            || handleDismissButton.bounds.contains(touch.location(in: handleDismissButton)) {
            return false
        } else {
            return true
        }
    }
}

private extension CGFloat {
    static let contentViewScale: CGFloat = UIScreen.main.bounds.height / 2.5
    static let textFieldWidth: CGFloat = 48
    static let labelHeight: CGFloat = 32
    static let labelWidth: CGFloat = 32
    static let remainderLabelWidth: CGFloat = 96
    static let separatorHeight: CGFloat = 1
    static let separatorWidth: CGFloat = 104
    static let handleDismissWidth: CGFloat = 44
    static let handleDismissHeight: CGFloat = 5
}
