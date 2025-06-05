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
    
    @Published var incomeText: String = ""
    private weak var coordinator: EnterNumberCoordinator?
    private let diContainer: AppDIContainer
    private var bag: Set<AnyCancellable> = []
    
    // MARK: - Initialization
    
    init(coordinator: EnterNumberCoordinator, diContainer: AppDIContainer) {
        self.coordinator = coordinator
        self.diContainer = diContainer
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
    
    // MARK: - Public Methods
    
    func openConfirmationScreen(with number: String) {
        let authService = diContainer.resolve(AuthServiceProtocol.self)
        authService.sendSMS(phoneNumber: number)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    print("Failed to send SMS:", error.localizedDescription)
                    return
                }
                self?.coordinator?.openConfirmationScreen(with: number)
            }, receiveValue: { _ in })
            .store(in: &bag)
    }
}
