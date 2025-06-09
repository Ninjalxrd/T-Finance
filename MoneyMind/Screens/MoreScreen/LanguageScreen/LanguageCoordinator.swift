//
//  LanguageCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 09.06.2025.
//

import Foundation
import UIKit

final class LanguageCoordinator {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let languageController = LanguageController()
        navigationController.pushViewController(languageController, animated: true)
    }
}
