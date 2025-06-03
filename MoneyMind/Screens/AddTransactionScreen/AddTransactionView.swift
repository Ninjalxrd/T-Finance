//
//  AddTransactionView.swift
//  MoneyMind
//
//  Created by Павел on 26.04.2025.
//

import UIKit
import SnapKit
import Combine

final class AddTransactionView: UIView {
    // MARK: - Properties
    private let categorySubject = PassthroughSubject<Void, Never>()
    var categoryPublisher: AnyPublisher<Void, Never> {
        categorySubject.eraseToAnyPublisher()
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements
    
    private lazy var titleLabel: UILabel = {
        let label = DefaultLabel(numberOfLines: 2, text: "Добавление\nтранзакции")
        return label
    }()
    
    private lazy var amountTextField: UITextField = {
        let textField = DefaultTextField(
            placeholder: "Сумма",
            textAlignment: .left,
            keyboardType: .numberPad
        )
        return textField
    }()
    
    private lazy var categoryButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
    
        configuration.title = "Категория"
        configuration.titleAlignment = .leading
        
        let attributedString = NSAttributedString(
            string: "Категория",
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
        
        let button = UIButton(configuration: configuration, primaryAction: categoryButtonAction)
        button.contentHorizontalAlignment = .fill
        button.tintColor = .secondaryText
        button.backgroundColor = .component
        button.layer.cornerRadius = Size.cornerRadius
        button.heightAnchor.constraint(equalToConstant: CGFloat.componentsHeight).isActive = true
        return button
    }()
    
    private lazy var categoryButtonAction = UIAction { [weak self] _ in
        self?.categorySubject.send()
    }
    
    private lazy var yesterdayButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Вчера", for: .normal)
        button.setTitleColor(.text, for: .normal)
        button.backgroundColor = .background
        button.layer.cornerRadius = Size.cornerRadius
        button.heightAnchor.constraint(equalToConstant: CGFloat.componentsHeight).isActive = true
        return button
    }()
    
    private lazy var todayButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сегодня", for: .normal)
        button.setTitleColor(.text, for: .normal)
        button.backgroundColor = .background
        button.layer.cornerRadius = Size.cornerRadius
        button.heightAnchor.constraint(equalToConstant: CGFloat.componentsHeight).isActive = true
        return button
    }()
    
    private lazy var otherDayButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Другой день", for: .normal)
        button.setTitleColor(.text, for: .normal)
        button.backgroundColor = .background
        button.layer.cornerRadius = Size.cornerRadius
        button.heightAnchor.constraint(equalToConstant: CGFloat.componentsHeight).isActive = true
        return button
    }()
    
    private lazy var dateStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [yesterdayButton, todayButton, otherDayButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.heightAnchor.constraint(equalToConstant: CGFloat.componentsHeight).isActive = true
        return stackView
    }()
    
    private lazy var addButton: UIButton = {
        let button = DefaultButton(title: "Добавить", action: addTransactionAction)
        button.heightAnchor.constraint(equalToConstant: CGFloat.componentsHeight).isActive = true
        return button
    }()
    
    private lazy var addTransactionAction = UIAction { _ in
        print("add")
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(amountTextField)
        addSubview(categoryButton)
        addSubview(dateStackView)
        addSubview(addButton)
        setupConstraints()
        setupShadows()
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Spacing.medium)
            make.leading.equalToSuperview().offset(Spacing.medium)
        }
        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Spacing.medium)
            make.leading.equalToSuperview().offset(Spacing.medium)
            make.trailing.equalToSuperview().offset(-Spacing.medium)
        }
        
        categoryButton.snp.makeConstraints { make in
            make.top.equalTo(amountTextField.snp.bottom).offset(Spacing.medium)
            make.leading.equalToSuperview().offset(Spacing.medium)
            make.trailing.equalToSuperview().offset(-Spacing.medium)
        }
        
        dateStackView.snp.makeConstraints { make in
            make.top.equalTo(categoryButton.snp.bottom).offset(Spacing.medium)
            make.leading.equalToSuperview().offset(Spacing.medium)
            make.trailing.equalToSuperview().offset(-Spacing.medium)
        }
        
        addButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-Spacing.medium)
            make.leading.equalToSuperview().offset(Spacing.medium)
            make.trailing.equalToSuperview().offset(-Spacing.medium)
        }
    }
    
    private func setupShadows() {
        dateStackView.arrangedSubviews.forEach {
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.2
            $0.layer.shadowOffset = CGSize(width: 4, height: 4)
            $0.layer.shadowRadius = Size.cornerRadius / 2
            $0.layer.masksToBounds = false
        }
    }
}

private extension CGFloat {
    static let componentsHeight: CGFloat = 56
}
