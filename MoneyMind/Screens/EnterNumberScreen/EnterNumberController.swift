//
//  EnterNumberController.swift
//  MoneyMind
//
//  Created by Павел on 23.04.2025.
//

import UIKit
import Combine

final class EnterNumberController: UIViewController {
    // MARK: - Private Properties
    
    private let enterNumberView: EnterNumberView = .init()
    private let viewModel: EnterNumberViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle

    init(viewModel: EnterNumberViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = enterNumberView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindViewModel()
        addObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    // MARK: - Setup Methods
    
    private func setupDelegates() {
        enterNumberView.numberTextField.delegate = self
    }
    
    // MARK: - Keyboard Handling
    
    private func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillChange),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }
    @objc private func handleKeyboardWillChange(notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }

        let keyboardHeight = view.convert(endFrame, from: nil).intersection(view.bounds).height
        let isKeyboardShowing = keyboardHeight > 0

        enterNumberView.bottomConstraint?.update(offset: -keyboardHeight)
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: UIView.AnimationOptions(rawValue: curveValue << 16),
            animations: {
                self.enterNumberView.logoStack.transform = isKeyboardShowing ?
                    CGAffineTransform(scaleX: 0.5, y: 0) :
                    .identity
                self.view.layoutIfNeeded()
            },
            completion: nil
        )
    }
    
    // MARK: - Binding Methods
    
    private func bindViewModel() {
        enterNumberView.numberTextField.textPublisher
            .assign(
                to: \.incomeText,
                on: viewModel)
            .store(in: &cancellables)
        
        viewModel.isInputValid
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                self?.enterNumberView.isInputValid(isValid)
            }
            .store(in: &cancellables)
    }
}

// MARK: - UITextFieldDelegate

extension EnterNumberController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        let allowedCharacters = CharacterSet(charactersIn: "+0123456789")
        let forbiddenCharacters = string.rangeOfCharacter(from: allowedCharacters.inverted)
        if forbiddenCharacters != nil && !string.isEmpty {
            return false
        }
        
        let cleanText = updatedText.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        if cleanText.count > 11 {
            return false
        }
        
        if cleanText.count == 1 && (string == "7" || string == "8") {
            textField.text = "+7"
            return false
        }
        return true
    }
}
