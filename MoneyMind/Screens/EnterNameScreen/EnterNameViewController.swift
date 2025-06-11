//
//  EnterNameViewController.swift
//  MoneyMind
//
//  Created by Павел on 25.04.2025.
//

import UIKit
import Combine

final class EnterNameViewController: UIViewController {
    // MARK: - Properties
    
    private let enterNameView: EnterNameView = .init()
    private let viewModel: EnterNameViewModel
    private var bag: Set<AnyCancellable> = []
    
    // MARK: - Lifecycle
    
    init(viewModel: EnterNameViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = enterNameView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCallbacks()
        setupNavigationBar()
    }
    
    // MARK: - Setup Methods
    private func setupCallbacks() {
        enterNameView.nextScreenPublisher
            .sink { [weak self] _ in
                self?.viewModel.openBudgetInputScreen()
            }
            .store(in: &bag)
    }
    
    private func setupNavigationBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
