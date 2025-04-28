//
//  EnterNumberViewModel.swift
//  MoneyMind
//
//  Created by Павел on 23.04.2025.
//

import Combine
import Foundation

final class EnterNumberViewModel {
    // MARK: - Properties
    private weak var coordinator: EnterNumberCoordinator?
    @Published var incomeText: String = ""
    
    // MARK: - Initialization
    
    init(coordinator: EnterNumberCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Validation Publishers
    
    var isInputValid: AnyPublisher<Bool, Never> {
        $incomeText
            .map(validatePhoneNumber)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Private Methods
    
    private func validatePhoneNumber(_ number: String) -> Bool {
        let phoneNumberRegex = #"^(\+7|8)[\s\-]?\(?9\d{2}\)?[\s\-]?\d{3}[\s\-]?\d{2}[\s\-]?\d{2}$"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        return predicate.evaluate(with: number)
    }
}
