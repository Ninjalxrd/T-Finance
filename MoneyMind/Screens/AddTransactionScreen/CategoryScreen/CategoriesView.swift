//
//  CategoriesView.swift
//  MoneyMind
//
//  Created by Павел on 03.06.2025.
//

import UIKit

final class CategoriesView: UIView {
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements
    
    private lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Поиск"
        search.backgroundImage = UIImage()
        search.tintColor = .secondaryText
        let searchIcon = UIImage(
            systemName: "magnifyingglass")?.withTintColor(
                .secondaryText,
                renderingMode: .alwaysOriginal
            )
        search.setImage(searchIcon, for: .search, state: .normal)
        search.frame = CGRect(
            x: 0,
            y: 0,
            width: UIScreen.main.bounds.width,
            height: Size.fieldHeight
        )
        
        let searchTextField = search.searchTextField
        searchTextField.backgroundColor = .component
        searchTextField.textColor = .text
        searchTextField.layer.cornerRadius = Size.cornerRadius
        searchTextField.layer.masksToBounds = true
        searchTextField.font = .systemFont(ofSize: 18)
        let placeholderAttributes: [NSAttributedString.Key: Any] =
        [.font: UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor.secondaryText]
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Поиск",
            attributes: placeholderAttributes
        )
        return search
    }()
    
    private lazy var categoriesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CategoriesCell.self, forCellReuseIdentifier: CategoriesCell.identifier)
        tableView.tableHeaderView = searchBar
        return tableView
    }()
    
    // MARK: - Setup UI
    
    private func setupUI() {
        backgroundColor = .background
        addSubview(categoriesTableView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        categoriesTableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Spacing.medium)
            make.leading.equalToSuperview().offset(Spacing.medium)
            make.trailing.equalToSuperview().offset(-Spacing.medium)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-Spacing.medium)
        }
    }
    
    // MARK: - Public Methods
    
    func setupTableViewDependencies(
        _ dataSource: UITableViewDataSource,
        _ delegate: UITableViewDelegate
    ) {
        categoriesTableView.delegate = delegate
        categoriesTableView.dataSource = dataSource
    }
    
    func setupSearchBarDependencies(_ delegate: UISearchBarDelegate) {
        searchBar.delegate = delegate
    }

    func reloadTableView() {
        DispatchQueue.main.async {
            self.categoriesTableView.reloadData()
        }
    }
    
    func hasSearchControllerText() -> Bool {
        guard let text = searchBar.text else { return false }
        return !text.isEmpty
    }
}
