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
        setupDependencies()
    }
    
    func setupDependencies() {
        moreView.setupSettingsTableViewDataSource(self)
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
}

extension MoreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ThemeCell.identifier, for: indexPath) as? ThemeCell else {
            return UITableViewCell()
        }
        setupSubscriptions(for: cell)
        return cell
    }
}
