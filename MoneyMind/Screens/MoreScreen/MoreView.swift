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
    let languageSelectionSubject = PassthroughSubject<Void, Never>()
    
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
        tableView.allowsSelection = true
        tableView.isScrollEnabled = false
        tableView.register(ThemeCell.self, forCellReuseIdentifier: ThemeCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LanguageCell")
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
        switch indexPath.section {
        case 0:
            return CGFloat.themeTableViewHeight
        case 1:
            return CGFloat.languageTableViewHeight
        default:
            return CGFloat.themeTableViewHeight
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let headerView = UIView()
            headerView.backgroundColor = .clear
            let titleLabel = DefaultTitleLabel(numberOfLines: 1, text: "Тема оформления")
            headerView.addSubview(titleLabel)

            titleLabel.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(Spacing.small)
                make.top.bottom.equalToSuperview().inset(Spacing.small)
            }
            return headerView
        case 1:
            let headerView = UIView()
            headerView.backgroundColor = .clear
            let titleLabel = DefaultTitleLabel(numberOfLines: 1, text: "Язык")
            headerView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(Spacing.small)
                make.top.bottom.equalToSuperview().inset(Spacing.small)
            }
            return headerView
        default:
            return UIView()
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 || section == 1 ? CGFloat.settingsHeightForHeader : 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section == 1 {
            languageSelectionSubject.send()
        }
    }
}

private extension CGFloat {
    static let themeTableViewHeight: CGFloat = 120
    static let languageTableViewHeight: CGFloat = 50
    static let settingsHeightForHeader: CGFloat = 80
}
