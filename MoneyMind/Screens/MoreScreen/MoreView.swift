//
//  MoreView.swift
//  MoneyMind
//
//  Created by Павел on 26.04.2025.
//

import UIKit
import SnapKit
import Combine

final class MoreView: UIView {
    // MARK: - Publishers
    let themeSelectionSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - TableView
    
    private lazy var settingsTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.separatorColor = .clear
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        tableView.register(ThemeCell.self, forCellReuseIdentifier: ThemeCell.identifier)
        return tableView
    }()
    
    // MARK: - Setter
    
    func setupSettingsTableViewDataSource(_ dataSource: UITableViewDataSource) {
        settingsTableView.dataSource = dataSource
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        addSubview(settingsTableView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        settingsTableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}

// MARK: - UITableViewDelegate

extension MoreView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat.settingsTableViewHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }

        let headerView = UIView()
        headerView.backgroundColor = .clear

        let titleLabel = DefaultTitleLabel(numberOfLines: 1, text: "Тема оформления")
        headerView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Spacing.medium)
            make.top.bottom.equalToSuperview().inset(Spacing.medium)
        }

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? CGFloat.settingsHeightForHeader : 0
    }
}

private extension CGFloat {
    static let settingsTableViewHeight: CGFloat = 120
    static let settingsHeightForHeader: CGFloat = 120
}
