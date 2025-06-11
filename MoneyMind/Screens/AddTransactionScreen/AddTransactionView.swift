//
//  AddTransactionView.swift
//  MoneyMind
//
//  Created by Павел on 26.04.2025.
//

import UIKit
import SnapKit
import Combine

private enum SelectedDate {
    case yesterday, today, other
}

final class AddTransactionView: UIView {
    // MARK: - Publishers
    
    private let addSubject = PassthroughSubject<Void, Never>()
    var addPublisher: AnyPublisher<Void, Never> {
        addSubject.eraseToAnyPublisher()
    }
    private let categorySubject = PassthroughSubject<Void, Never>()
    var categoryPublisher: AnyPublisher<Void, Never> {
        categorySubject.eraseToAnyPublisher()
    }
    private let otherDaySubject = PassthroughSubject<Void, Never>()
    var otherDayPublisher: AnyPublisher<Void, Never> {
        otherDaySubject.eraseToAnyPublisher()
    }
    let daySubject = CurrentValueSubject<Date, Never>(Date())

    // MARK: - Properties
    
    private var selectedDate: SelectedDate = .today {
        didSet {
            updateDateButtonsAppearance()
        }
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
        let label = DefaultTitleLabel(numberOfLines: 2, text: "Добавление\nтранзакции")
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
    
    // MARK: - Getter
    
    func getAmountTextField() -> UITextField {
        return amountTextField
    }
    
    // MARK: - Setter
    
    func setAmountText(_ text: String) {
        amountTextField.text = text
    }
    
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
        let button = UIButton(
            configuration: dateButtonConfiguration(
                title: "Вчера",
                isSelected: selectedDate == .yesterday
            ),
            primaryAction: UIAction { [weak self] _ in
                guard let self else { return }
                guard
                    let date = Calendar.current.date(byAdding: .day, value: -1, to: Date())
                else { return }
                self.daySubject.send(date)
                self.selectedDate = .yesterday
            }
        )
        button.heightAnchor.constraint(equalToConstant: CGFloat.componentsHeight).isActive = true
        return button
    }()
    
    private lazy var todayButton: UIButton = {
        let button = UIButton(
            configuration: dateButtonConfiguration(
                title: "Сегодня",
                isSelected: selectedDate == .today)
            , primaryAction: UIAction { [weak self] _ in
                let date = Date()
                self?.daySubject.send(date)
                self?.selectedDate = .today
            }
        )
        button.heightAnchor.constraint(equalToConstant: CGFloat.componentsHeight).isActive = true
        return button
    }()
    
    private lazy var otherDayButton: UIButton = {
        let button = UIButton(
            configuration: dateButtonConfiguration(
                title: "Другой день",
                isSelected: selectedDate == .other),
            primaryAction: UIAction { [weak self] _ in
                self?.selectedDate = .other
                self?.otherDaySubject.send()
            }
        )
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
    
    private lazy var addTransactionAction = UIAction { [weak self] _ in
        self?.endEditing(true)
        self?.addSubject.send()
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
    
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.delegate = self
        tap.cancelsTouchesInView = false
        return tap
    }()
    
    @objc func tapAction() {
        self.endEditing(true)
    }
    
    // MARK: - Private Methods
    
    private func dateButtonConfiguration(title: String, isSelected: Bool) -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.baseForegroundColor = .text
        config.baseBackgroundColor = .background
        config.cornerStyle = .medium
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        if isSelected {
            config.background.strokeColor = .myBlue
            config.background.strokeWidth = 2
        } else {
            config.background.strokeWidth = 0
        }
        
        return config
    }
    
    private func updateDateButtonsAppearance() {
        yesterdayButton.configuration = dateButtonConfiguration(
            title: "Вчера",
            isSelected: selectedDate == .yesterday
        )
        todayButton.configuration = dateButtonConfiguration(
            title: "Сегодня",
            isSelected: selectedDate == .today
        )
        otherDayButton.configuration = dateButtonConfiguration(
            title: "Другой день",
            isSelected: selectedDate == .other
        )
    }
    
    // MARK: - Setter
    
    func setCategoryTitle(_ string: String?) {
        let title = string ?? "Категория"
        categoryButton.setTitle(title, for: .normal)
        if string != nil {
            categoryButton.setTitleColor(.text, for: .normal)
        } else {
            categoryButton.setTitleColor(.placeholderText, for: .normal)
        }
    }
    
    // MARK: - Public
    
    func setNextScreenButtonEnabled(_ isEnabled: Bool) {
        addButton.isEnabled = isEnabled
        addButton.alpha = isEnabled ? 1.0 : 0.5
    }
    
    func setupTextFieldDelegate(_ delegate: UITextFieldDelegate) {
        amountTextField.delegate = delegate
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(amountTextField)
        addSubview(categoryButton)
        addSubview(dateStackView)
        addSubview(addButton)
        addGestureRecognizer(tapGestureRecognizer)
        addGestureRecognizer(downSwipeGestureRecognizer)
        updateDateButtonsAppearance()
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
            make.bottom.equalTo(keyboardLayoutGuide.snp.top).offset(-Spacing.medium)
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

// MARK: - UIGestureRecognizerDelegate

extension AddTransactionView:
    UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch
    ) -> Bool {
        if let view = touch.view, view is UIButton {
            return false
        }
        return true
    }
}

private extension CGFloat {
    static let componentsHeight: CGFloat = 56
}
