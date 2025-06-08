//
//  DetailGoalController.swift
//  MoneyMind
//
//  Created by Павел on 07.06.2025.
//

import UIKit

class DetailGoalController: UIViewController {
    private let detailGoalView = DetailGoalView()
    private let detailViewModel: DetailViewModel
    
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
    }
    
    private func configureView() {
        detailGoalView.configureView(with: detailViewModel.goal)
        detailGoalView.configureProgressBar(
            current: detailViewModel.goal.accumulatedAmount,
            total: detailViewModel.goal.amount
        )
    }
}
