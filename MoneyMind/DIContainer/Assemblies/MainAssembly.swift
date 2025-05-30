//
//  MainAssembly.swift
//  MoneyMind
//
//  Created by Павел on 20.05.2025.
//

import Swinject
import UIKit

final class MainAssembly: Assembly {
    func assemble(container: Container) {
        // MARK: - Services

        container.register(GoalsManagerProtocol.self) { _ in
            GoalsManager()
        }
        .inObjectScope(.container)
    }
}
