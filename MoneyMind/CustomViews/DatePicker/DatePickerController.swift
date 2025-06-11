//
//  DatePickerController.swift
//  MoneyMind
//
//  Created by Павел on 03.06.2025.
//

import UIKit
import SnapKit
import Combine

enum DatePickerMode {
    case transaction
    case goal
}

final class DatePickerViewController: UIViewController {
    // MARK: - Properties
    
    private let mode: DatePickerMode
    private let dateSubject: CurrentValueSubject<Date, Never>

    // MARK: Init
    init(mode: DatePickerMode, dateSubject: CurrentValueSubject<Date, Never>) {
        self.mode = mode
        self.dateSubject = dateSubject
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMaxDate()
        setupUI()
    }
    
    // MARK: - UI Elements
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .inline
        return picker
    }()
    
    private func setupMaxDate() {
        switch mode {
        case .transaction:
            datePicker.maximumDate = Date()
            datePicker.datePickerMode = .dateAndTime
        case .goal:
            datePicker.maximumDate = .distantFuture
            datePicker.minimumDate = Date()
            datePicker.datePickerMode = .date
        }
    }
    
    private lazy var doneButton: UIButton = {
        let button = DefaultButton(title: "Готово", action: doneAction)
        button.heightAnchor.constraint(equalToConstant: Size.buttonHeight).isActive = true
        return button
    }()
    
    private lazy var doneAction = UIAction { [weak self] _ in
        guard let self else { return }
        self.dateSubject.send(self.datePicker.date)
        self.dismiss(animated: true)
    }

    // MARK: - Setup UI
    
    private func setupUI() {
        view.backgroundColor = .background
        view.addSubview(datePicker)
        view.addSubview(doneButton)
        setupConstaints()
    }
    
    private func setupConstaints() {
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Spacing.medium)
            make.leading.trailing.equalToSuperview().inset(Spacing.medium)
        }
        
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(Spacing.medium)
            make.leading.trailing.equalToSuperview().inset(Spacing.medium)
        }
    }
}
