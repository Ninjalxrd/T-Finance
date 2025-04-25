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
    var timerFinished = PassthroughSubject<Void, Never>()
    
    // MARK: - Properties
    
    private let defaultWaitingValue: Int = 5
    private var remainingSeconds: Int
    private var timer: AnyCancellable?
    
    // MARK: Init
    
    init() {
        self.remainingSeconds = defaultWaitingValue
    }
    
    // MARK: - Methods
    
    func startTimer() {
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
}
