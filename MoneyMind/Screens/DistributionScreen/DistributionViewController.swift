//
//  DistributionViewController.swift
//  MoneyMind
//
//  Created by Павел on 13.04.2025.
//

import UIKit
import Combine
import SkeletonView

// MARK: - Enum

enum Sections: CaseIterable {
    case picked
    case available
}

class DistributionViewController: UIViewController {
    // MARK: - Properties
    
    private let distributionView: DistributionView = .init()
    private let distributionViewModel: DistributionViewModel
    private var bag = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    
    init(distributionViewModel: DistributionViewModel) {
        self.distributionViewModel = distributionViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = distributionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        addCollectionViewDependencies()
        setupCallbacks()
        bindViewModel()
        setupNavigationBar()
    }

    // MARK: Setup Methods
    
    private func addCollectionViewDependencies() {
        distributionView.setCollectionViewDelegate(self)
        distributionView.setCollectionViewDataSource(self)
    }
    
    private func bindViewModel() {
        distributionView.showCollectionSkeletonAnimations()
        distributionViewModel.$pickedCategories
            .receive(on: DispatchQueue.main)
            .sink { [weak self] picked in
                if picked.isEmpty {
                    self?.distributionView.showCollectionSkeletonAnimations()
                } else {
                    self?.distributionView.hideSkeletonAnimations()
                }
                self?.distributionView.updateChart(with: picked)
                self?.distributionView.setNextScreenButtonEnabled(!picked.isEmpty)
                self?.distributionView.reloadData()
            }
            .store(in: &bag)
        
        distributionView.showCollectionSkeletonAnimations()
        distributionViewModel.$availableCategories
            .receive(on: DispatchQueue.main)
            .sink { [weak self] categories in
                if categories.isEmpty {
                    self?.distributionView.showCollectionSkeletonAnimations()
                } else {
                    self?.distributionView.hideSkeletonAnimations()
                    self?.distributionView.reloadData()
                }
            }
            .store(in: &bag)
    }
    
    private func setupCallbacks() {
        distributionView.nextScreenPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.distributionViewModel.openMainScreen()
            }
            .store(in: &bag)
    }
    
    private func setupNavigationBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

// MARK: Extensions of UICollectionView

extension DistributionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sections = Sections.allCases[indexPath.section]
        switch sections {
        case .available:
            if distributionViewModel.remainingPercent > 0 {
                distributionViewModel.selectAvailableItem(indexPath: indexPath)
            } else {
                distributionViewModel.showError()
            }
        case .picked:
            distributionViewModel.deselectCategory(at: indexPath)
        }
    }
}

extension DistributionViewController: SkeletonCollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = Sections.allCases[section]
        switch sectionType {
        case .available:
            return distributionViewModel.availableCategories.count
        case .picked:
            return distributionViewModel.pickedCategories.count
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let section = Sections.allCases[indexPath.section]

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DistributionCollectionViewCell.identifier,
            for: indexPath) as? DistributionCollectionViewCell
        else { return UICollectionViewCell() }
        
        let category: Category
        
        switch section {
        case .available:
            category = distributionViewModel.availableCategories[indexPath.item]
            cell.configure(with: category, isPicked: false)
        case .picked:
            category = distributionViewModel.pickedCategories[indexPath.item]
            cell.configure(with: category, isPicked: true)
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Sections.allCases.count
    }
    
    func collectionSkeletonView(
        _ skeletonView: UICollectionView,
        cellIdentifierForItemAt indexPath: IndexPath
    ) -> SkeletonView.ReusableCellIdentifier {
        return DistributionCollectionViewCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
}
