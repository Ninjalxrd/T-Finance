//
//  ConfirmationViewController.swift
//  MoneyMind
//
//  Created by Павел on 24.04.2025.
//

import UIKit
import Combine

final class ConfirmationViewController: UIViewController {
    // MARK: - Properties
    private var confirmationView: ConfirmationView = .init()
    private let viewModel: ConfirmationViewModel
    private var timer: Timer?
    private var bag = Set<AnyCancellable>()
    private let number: String
    private let codeLength = 4
    
    // MARK: - Lifecycle
    
    init(viewModel: ConfirmationViewModel, number: String) {
        self.viewModel = viewModel
        self.number = number
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = confirmationView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmationView.configureLabel(with: number)
        onStartTimer()
        bindViewModel()
        setupCallbacks()
        setupDelegates()
    }
    
    private func setupDelegates() {
        confirmationView.setupTextFieldDelegate(self)
    }
    
    private func bindViewModel() {
        viewModel.$remainingTimeText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.confirmationView.setupTimerLabelText("Запросить через: \(text ?? "00:00")")
            }
            .store(in: &bag)
        
        viewModel.timerFinished
            .sink { [weak self] _ in
                self?.confirmationView.toggleHideNewCodeButton(false)
                self?.confirmationView.toggleHideTimerLabel(true)
            }
            .store(in: &bag)
        
        viewModel.didAuthorize
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.confirmationView.showSuccessState()
            }
            .store(in: &bag)
        
        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                guard let self = self else { return }
                print(123)
                shakeTextField(confirmationView.getCodeTextField())
                confirmationView.showErrorMessage(message)
                confirmationView.cleanTextField()
            }
            .store(in: &bag)
    }
    
    private func setupCallbacks() {
        confirmationView.newCodePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.onStartTimer()
            }
            .store(in: &bag)
    }
    
    private func onStartTimer() {
        viewModel.startTimer()
        confirmationView.toggleHideNewCodeButton(true)
        confirmationView.toggleHideTimerLabel(false) 
    }
}

extension ConfirmationViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        let isNumeric = updatedText.allSatisfy { $0.isNumber }
        return updatedText.count <= codeLength && isNumeric
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text, text.count == codeLength else { return }
        viewModel.confirmCode(text)
    }
}

// MARK: - Animations
extension ConfirmationViewController {
    private func shakeTextField(_ textField: UITextField) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: textField.center.x - 5, y: textField.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: textField.center.x + 5, y: textField.center.y))
        textField.layer.add(animation, forKey: "position")
    }
}
