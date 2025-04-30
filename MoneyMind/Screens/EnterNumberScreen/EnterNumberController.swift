//
//  EnterNumberController.swift
//  MoneyMind
//
//  Created by Павел on 23.04.2025.
//

import UIKit
import Combine
import PhoneNumberKit

final class EnterNumberController: UIViewController {
    // MARK: - Private Properties
    
    private let enterNumberView: EnterNumberView = .init()
    private let viewModel: EnterNumberViewModel
    private var bag = Set<AnyCancellable>()
    
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
        setupCallbacks()
        bindViewModel()
        addObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupCallbacks() {
        enterNumberView.nextScreenPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.viewModel.openConfirmationScreen(with: enterNumberView.getNumber())
            }
            .store(in: &bag)
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
                CGAffineTransform(scaleX: 0, y: 0) :
                    .identity
                self.view.layoutIfNeeded()
            },
            completion: nil
        )
    }
    
    // MARK: - Binding Methods
    
    private func bindViewModel() {
        enterNumberView.numberTextFieldPublisher
            .assign(
                to: \.incomeText,
                on: viewModel)
            .store(in: &bag)
        
        viewModel.isInputValid
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                self?.enterNumberView.isInputValid(isValid)
            }
            .store(in: &bag)
    }
}
