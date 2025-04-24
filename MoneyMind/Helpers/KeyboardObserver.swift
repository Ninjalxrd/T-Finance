//
//  KeyboardObserver.swift
//  MoneyMind
//
//  Created by Павел on 22.04.2025.
//

import Combine
import Foundation
import UIKit

final class KeyboardObserver {
    let keyboardHeight: AnyPublisher<CGFloat, Never>
    private let subject = PassthroughSubject<CGFloat, Never>()

    init(center: NotificationCenter = .default) {
        keyboardHeight = subject.eraseToAnyPublisher()
        center.addObserver(
            self,
            selector: #selector(willShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        center.addObserver(
            self,
            selector: #selector(willHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }

    @objc private func willShow(_ note: Notification) {
        guard
            let frame = (note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }
        subject.send(frame.height)
    }

    @objc private func willHide(_ note: Notification) {
        subject.send(0)
    }
}
