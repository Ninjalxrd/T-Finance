//
//  DetailGoalController.swift
//  MoneyMind
//
//  Created by Павел on 07.06.2025.
//

import UIKit
import Combine

class DetailGoalController: UIViewController {
    private let detailGoalView = DetailGoalView()
    private let detailViewModel: DetailViewModel
    private var bag: Set<AnyCancellable> = []
    
    // MARK: - Lifecycle
    
    init(detailViewModel: DetailViewModel) {
        self.detailViewModel = detailViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = detailGoalView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupCallbacks()
        setupNavigationBar()
    }

    private func configureView() {
        detailGoalView.configureView(with: detailViewModel.goal)
        detailGoalView.configureProgressBar(
            current: detailViewModel.goal.accumulatedAmount,
            total: detailViewModel.goal.amount
        )
    }
    
    private func setupCallbacks() {
        detailGoalView.editPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.detailViewModel.openEditScreen()
            }
            .store(in: &bag)
    }
    
    private func setupNavigationBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
