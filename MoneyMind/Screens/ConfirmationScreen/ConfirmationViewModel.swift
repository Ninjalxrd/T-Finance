//
//  ConfirmationViewModel.swift
//  MoneyMind
//
//  Created by Павел on 24.04.2025.
//

import Foundation
import Combine

final class ConfirmationViewModel {
    // MARK: - Published Properties

    @Published private(set) var remainingTimeText: String?
    @Published var errorMessage: String?
    
    var timerFinished = PassthroughSubject<Void, Never>()
    var didAuthorize = PassthroughSubject<Void, Never>()
    
    // MARK: - Properties
    
    private weak var coordinator: ConfirmationCoordinator?
    private let diContainer: AppDIContainer
    private let defaultWaitingValue: Int = 5
    private var remainingSeconds: Int
    private var timer: AnyCancellable?
    private var bag: Set<AnyCancellable> = []
    
    private let authService = AuthService()
    private let phoneNumber: String
    // MARK: Init
    
    init(coordinator: ConfirmationCoordinator, phoneNumber: String, diContainer: AppDIContainer) {
        self.coordinator = coordinator
        self.remainingSeconds = defaultWaitingValue
        self.phoneNumber = phoneNumber
        self.diContainer = diContainer
    }
    
    // MARK: - Methods
    
    func startTimer() {
        timer?.cancel()
        remainingTimeText = formatTime(defaultWaitingValue)
        timer = Timer
            .publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.perSecond()
            }
    }
    
    private func perSecond() {
        guard remainingSeconds > 0 else {
            timer?.cancel()
            timerFinished.send()
            remainingSeconds = defaultWaitingValue
            remainingTimeText = formatTime(defaultWaitingValue)
            return
        }
        
        remainingSeconds -= 1
        remainingTimeText = formatTime(remainingSeconds)
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // MARK: - Network
    
    func confirmCode(_ code: String) {
        let keychainManager = diContainer.resolve(KeychainManagerProtocol.self)
        authService
            .confirmSMS(phoneNumber: phoneNumber, code: code)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    print("Error: \(error)")
                    let message = self?.errorMessage(for: error) ?? "Неизвестная ошибка"
                    self?.errorMessage = message
                }
            } receiveValue: { [weak self] response in
                print("Received response: \(response)")
                UserManager.shared.isRegistered = true
                keychainManager.saveAccessToken(response.accessToken)
                keychainManager.saveRefreshToken(response.refreshToken)
                self?.didAuthorize.send()
                self?.coordinator?.openEnterNameScreen()
            }
            .store(in: &bag)
    }
    
    private func errorMessage(for error: Error) -> String {
        if let afError = error.asAFError, afError.isResponseValidationError {
            return "Неверный код подтверждения"
        }
        return "Ошибка сети. Проверьте соединение"
    }
}
