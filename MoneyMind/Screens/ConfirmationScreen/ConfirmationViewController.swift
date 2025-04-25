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
    
    // MARK: - Lifecycle
    
    init(viewModel: ConfirmationViewModel) {
        self.viewModel = viewModel
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
        confirmationView.configureLabel(with: "+7(917)-893-26-83")
        onStartTimer()
        bindViewModel()
        setupCallbacks()
    }
    
    private func bindViewModel() {
        viewModel.$remainingTimeText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.confirmationView.timerLabel.text = "Запросить через: \(text ?? "00:00")"
            }
            .store(in: &bag)
        
        viewModel.timerFinished
            .sink { [weak self] _ in
                self?.confirmationView.newCodeButton.isHidden = false
                self?.confirmationView.timerLabel.isHidden = true
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
        confirmationView.newCodeButton.isHidden = true
        confirmationView.timerLabel.isHidden = false
    }
}

// MARK: - Timer
extension ConfirmationViewController {
}
