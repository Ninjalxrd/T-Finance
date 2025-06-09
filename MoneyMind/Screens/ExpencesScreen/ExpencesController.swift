//
//  ExpencesController.swift
//  MoneyMind
//
//  Created by Павел on 26.04.2025.
//

import UIKit
import Combine
import SkeletonView

final class ExpencesController: UIViewController {
    private let viewModel: ExpencesViewModel
    private let expencesView = ExpencesView()
    private var bag: Set<AnyCancellable> = []
    
    init(viewModel: ExpencesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = expencesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCallbacks()
        bindViewModel()
        setupTableView()
        setupNavigationBar()
    }
    
    private func setupTableView() {
        expencesView.setupExpenceTableView(self, self)
    }
    
    private func bindViewModel() {
        viewModel.$expensesCategories
            .receive(on: DispatchQueue.main)
            .sink { [weak self] categories in
                self?.expencesView.updateExpensesChart(with: categories)
            }
            .store(in: &bag)
        
        expencesView.showTableViewSkeleton()
        viewModel.$expences
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] expences in
                if expences.isEmpty {
                    self?.expencesView.showTableViewSkeleton()
                } else {
                    self?.expencesView.hideTableViewSkeleton()
                }
                self?.expencesView.endRefreshing()
                self?.expencesView.reloadExpencesTableView()
            }
            .store(in: &bag)
        
        viewModel.$totalExpenses
            .receive(on: DispatchQueue.main)
            .sink { [weak self] totalSum in
                self?.expencesView.updateTotalExpenses(amount: totalSum)
            }
            .store(in: &bag)
    }
    
    private func setupCallbacks() {
        expencesView.refreshPublisher
            .subscribe(viewModel.refreshSubject)
            .store(in: &bag)
        expencesView.periodPublisher
            .subscribe(viewModel.periodSubject)
            .store(in: &bag)
    }
    
    private func setupNavigationBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
// MARK: - UITableViewDelegate, UITableViewDataSource

extension ExpencesController: UITableViewDelegate, SkeletonTableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.expences.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ExpenceCell.identifier,
            for: indexPath) as? ExpenceCell else {
            return UITableViewCell()
        }
        let expence = viewModel.expences[indexPath.row]
        cell.configure(with: expence)
        
        viewModel.getImageByURL(expence.category.icon) { image in
            DispatchQueue.main.async {
                cell.configureCellIcon(with: image)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.loadNextPageIfNeeded(currentIndex: indexPath.row)
    }
    
    func collectionSkeletonView(
        _ skeletonView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 6
    }

    func collectionSkeletonView(
        _ skeletonView: UITableView,
        cellIdentifierForRowAt indexPath: IndexPath
    ) -> ReusableCellIdentifier {
        return ExpenceCell.identifier
    }
}
