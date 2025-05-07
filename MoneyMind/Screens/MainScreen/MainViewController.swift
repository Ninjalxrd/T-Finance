//
//  MainViewController.swift
//  MoneyMind
//
//  Created by Павел on 26.04.2025.
//

import UIKit
import Combine
import SkeletonView

class MainViewController: UIViewController {
    // MARK: - Properties
    
    private let viewModel: MainViewModel
    private let mainView: MainView = .init(frame: .zero)
    private var bag: Set<AnyCancellable> = []
    private var lastExpences: [Expence] = []
    
    // MARK: - Lifecycle
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChart()
        setupView()
        bindViewModel()
    }
    
    // MARK: - Private Methods
    
    private func setupChart() {
        let categories = UserManager.shared.categories
        mainView.updateChartView(with: categories)
    }
    
    private func setupView() {
        let budget = UserManager.shared.budget
        mainView.setupBudget(with: budget)
        
        mainView.setupTableViewDelegate(self)
        mainView.setupTableViewDataSource(self)
    }
    
    private func bindViewModel() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case .loading:
                    self.mainView.showSkeletonAnimations()
                case .content(let content):
                    self.lastExpences = content
                    self.mainView.reloadTableView()
                    self.mainView.hideSkeletonAnimations()
                case .error(_):
                    self.mainView.hideSkeletonAnimations()
//                    self.mainView.showError()
                }
            }
            .store(in: &bag)
    }
}

// MARK: - Extensions

extension MainViewController: UITableViewDelegate, SkeletonTableViewDataSource {
    // MARK: - TableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lastExpences.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ExpencesTableViewCell.identifier, for: indexPath) as? ExpencesTableViewCell
        else {
            return UITableViewCell()
        }
        cell.configureCell(with: lastExpences[indexPath.row])
        return cell
    }
    
    // MARK: - Skeleton TableView DataSource
    
    func collectionSkeletonView(
        _ skeletonView: UITableView,
        cellIdentifierForRowAt indexPath: IndexPath
    ) -> ReusableCellIdentifier {
        return ExpencesTableViewCell.identifier
    }
    
    func collectionSkeletonView(
        _ skeletonView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 3
    }
    
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1
    }
    
    // MARK: - TableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat.tableViewRowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

private extension CGFloat {
    static let tableViewRowHeight: CGFloat = 56
}
