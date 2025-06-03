//
//  CategoriesViewController.swift
//  MoneyMind
//
//  Created by Павел on 03.06.2025.
//

import UIKit
import Combine

final class CategoriesViewController: UIViewController {
    private let categoriesView = CategoriesView()
    private let viewModel: CategoriesViewModel
    private var bag: Set<AnyCancellable> = []
    private var isFiltering: Bool {
        categoriesView.hasSearchControllerText()
    }
    
    init(viewModel: CategoriesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = categoriesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupDependencies()
    }
    
    private func setupDependencies() {
        categoriesView.setupTableViewDependencies(self, self)
        categoriesView.setupSearchBarDependencies(self)
    }
        
    private func bindViewModel() {
        viewModel.$categories
            .sink { [weak self] _ in
                self?.categoriesView.reloadTableView()
            }
        
            .store(in: &bag)
        viewModel.$filteredCategories
            .sink { [weak self] _ in
                self?.categoriesView.reloadTableView()
            }
            .store(in: &bag)
    }
}

extension CategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? viewModel.filteredCategories.count : viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesCell.identifier, for: indexPath)
                as? CategoriesCell
        else { return UITableViewCell() }
        let category = isFiltering ? viewModel.filteredCategories[indexPath.row] : viewModel.categories[indexPath.row]
        cell.configureCell(with: category)
        viewModel.getImageByURL(category.icon) { image in
            DispatchQueue.main.async {
                cell.configureIcon(with: image)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat.cellHeight
    }
}
    
extension CategoriesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let query = searchText.lowercased()
        if query.isEmpty {
            viewModel.filteredCategories = viewModel.categories
        } else {
            viewModel.filteredCategories = viewModel.categories.filter {
                $0.name.lowercased().contains(query)
            }
        }
    }
}

private extension CGFloat {
    static let cellHeight: CGFloat = 70
}
