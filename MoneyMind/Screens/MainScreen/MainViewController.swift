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
    
    private let mainView: MainView = .init(frame: .zero)
    private var bag: Set<AnyCancellable> = []
    private var lastExpences: [Expence] = []
    private var lastGoals: [Goal] = []
    let viewModel: MainViewModel
    
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
        setupCallbacks()
        setupNavigationBar()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.getLastGoals()
        viewModel.getLastExpences()
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
        viewModel.$expencesState
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case .loading:
                    mainView.showExpencesSkeletonAnimations()
                case .content(let content):
                    self.lastExpences = content
                    self.mainView.reloadExpencesTableView()
                    self.mainView.hideExpencesSkeletonAnimations()
                default:
                    break
                }
            }
            .store(in: &bag)
        
        viewModel.$goalsState
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case .loading:
                    mainView.showGoalsSkeletonAnimations()
                case .content(let content):
                    self.lastGoals = content
                    self.mainView.reloadGoalsTableView()
                    self.mainView.hideGoalsSkeletonAnimations()
                default:
                    break
                }
            }
            .store(in: &bag)
        
        viewModel.$balance
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.mainView.setupBudget(with: self.viewModel.balance)
            }
            .store(in: &bag)
    }
    
    private func setupCallbacks() {
        mainView.expensesScreenPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                self.viewModel.openExpencesScreen()
            }
            .store(in: &bag)
        
        mainView.goalsScreenPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                self.viewModel.openGoalsScreen()
            }
            .store(in: &bag)
    }
    
    private func setupNavigationBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

// MARK: - Extensions

extension MainViewController: UITableViewDelegate, SkeletonTableViewDataSource {
    // MARK: - TableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == mainView.getExpencesTableView() {
            return lastExpences.count
        } else {
            return lastGoals.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == mainView.getExpencesTableView() {
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: ExpencesTableViewCell.identifier, for: indexPath) as? ExpencesTableViewCell
            else {
                return UITableViewCell()
            }
            let expence = lastExpences[indexPath.row]
            cell.configureCell(with: expence)
            
            viewModel.getImageByURL(expence.category.icon) { image in
                DispatchQueue.main.async {
                    cell.configureCellIcon(with: image)
                }
            }
            return cell
        } else {
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: GoalsTableViewCell.identifier, for: indexPath) as?
                    GoalsTableViewCell
            else {
                return UITableViewCell()
            }
            cell.configureCell(with: lastGoals[indexPath.row])
            return cell
        }
    }
    
    // MARK: - Skeleton TableView DataSource
    
    func collectionSkeletonView(
        _ skeletonView: UITableView,
        cellIdentifierForRowAt indexPath: IndexPath
    ) -> ReusableCellIdentifier {
        if skeletonView == mainView.getExpencesTableView() {
            return ExpencesTableViewCell.identifier
        } else {
            return GoalsTableViewCell.identifier
        }
    }

    func collectionSkeletonView(
        _ skeletonView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 3
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
