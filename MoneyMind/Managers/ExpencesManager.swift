//
//  ExpencesManager.swift
//  MoneyMind
//
//  Created by Павел on 05.05.2025.
//

import Combine
import UIKit

protocol ExpencesManagerProtocol {
    var allExpences: [Expence] { get }
    var allExpencesPublisher: AnyPublisher<[Expence], Never> { get }
    func fetchFromServer()
}

final class ExpencesManager: ExpencesManagerProtocol {
    // MARK: - Published Properties
        @Published private(set) var allExpences: [Expence] = []
        
        // MARK: - Public Properties
        var allExpencesPublisher: AnyPublisher<[Expence], Never> {
            $allExpences.eraseToAnyPublisher()
        }
        
        // MARK: - Private Properties
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Methods
    
    func fetchFromServer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.allExpences = [
                Expence(
                    id: 1,
                    image: UIImage(named: "expenceImage") ?? UIImage(),
                    shop: "Пятерочка",
                    category: "Продукты",
                    sum: 1253),
                Expence(
                    id: 2,
                    image: UIImage(named: "expenceImage") ?? UIImage(),
                    shop: "Авито",
                    category: "Продукты",
                    sum: 2490),
                Expence(
                    id: 3,
                    image: UIImage(named: "expenceImage") ?? UIImage(),
                    shop: "Champion Gym",
                    category: "Активный отдых",
                    sum: 250),
                Expence(
                    id: 4,
                    image: UIImage(named: "expenceImage") ?? UIImage(),
                    shop: "Lava.top",
                    category: "Цифровые продукты",
                    sum: 450)
            ]
        }
    }
}
