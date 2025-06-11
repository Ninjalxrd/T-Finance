//
//  MoreViewController.swift
//  MoneyMind
//
//  Created by Павел on 26.04.2025.
//

import UIKit
import Combine

final class MoreViewController: UIViewController {
    private let viewModel: MoreViewModel
    private let moreView = MoreView()
    private var bag: Set<AnyCancellable> = []
    
    init(viewModel: MoreViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = moreView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupDependencies()
        setupCallbacks()
    }
    
    func setupDependencies() {
        moreView.setupSettingsTableViewDataSource(self)
    }
    
    private func setupCallbacks() {
        moreView.languageSelectionSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.openLanguageScreen()
            }
            .store(in: &bag)
    }
    
    private func setupSubscriptions(for cell: ThemeCell) {
        cell.systemThemePublisher
            .sink { [weak self] in
                guard let self = self else { return }
                UserManager.shared.theme = Theme(rawValue: 0) ?? .dark
                view.window?.overrideUserInterfaceStyle = UserManager.shared.theme.getUserInterfaceStyle()
            }
            .store(in: &bag)
        
        cell.lightThemePublisher
            .sink { [weak self] in
                guard let self = self else { return }
                UserManager.shared.theme = Theme(rawValue: 1) ?? .dark
                view.window?.overrideUserInterfaceStyle = UserManager.shared.theme.getUserInterfaceStyle()
            }
            .store(in: &bag)
        
        cell.darkThemePublisher
            .sink { [weak self] in
                guard let self = self else { return }
                UserManager.shared.theme = Theme(rawValue: 2) ?? .dark
                view.window?.overrideUserInterfaceStyle = UserManager.shared.theme.getUserInterfaceStyle()
            }
            .store(in: &bag)
    }
    
    private func setupNavigationBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

extension MoreViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ThemeCell.identifier,
                for: indexPath) as? ThemeCell
            else {
                return UITableViewCell()
            }
            setupSubscriptions(for: cell)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath)
            var config = UIListContentConfiguration.valueCell()
            config.text = "Сменить язык"
            config.secondaryText = "Русский"
            cell.contentConfiguration = config
            cell.accessoryType = .disclosureIndicator
            return cell
        default:
            return UITableViewCell()
        }
    }
}
