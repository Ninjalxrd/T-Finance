//
//  ProcentDetailsCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 01.05.2025.
//
import UIKit
import Combine

final class ProcentDetailsCoordinator: Coordinator {
    // MARK: - Properties

    private let navigationController: UINavigationController
    private let transitionDelegate = CustomTransitioningDelegate()
    private let budget: Int
    private let remainingPercent: Int
    private let selectedCategory: Category
    private let onCategoryAdded: (Category) -> Void
    private var cancellables = Set<AnyCancellable>()
    
    var childCoordinators: [Coordinator] = []

    // MARK: - Init

    init(
        navigationController: UINavigationController,
        budget: Int,
        remainingPercent: Int,
        selectedCategory: Category,
        onCategoryAdded: @escaping (Category) -> Void
    ) {
        self.navigationController = navigationController
        self.budget = budget
        self.remainingPercent = remainingPercent
        self.selectedCategory = selectedCategory
        self.onCategoryAdded = onCategoryAdded
    }

    // MARK: - Public Methods

    func start() {
        let controller = ProcentDetailsController(
            budget: budget,
            remainingPercent: remainingPercent,
            selectedCategory: selectedCategory
        )

        controller.onAddCategory
            .sink { [weak self] categoryData in
                self?.onCategoryAdded(categoryData)
            }
            .store(in: &cancellables)

        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = transitionDelegate
        controller.isModalInPresentation = true

        navigationController.present(controller, animated: true)
    }
}
