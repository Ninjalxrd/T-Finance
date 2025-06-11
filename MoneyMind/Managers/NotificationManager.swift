//
//  NotificationManager.swift
//  MoneyMind
//
//  Created by Павел on 09.06.2025.
//

import UserNotifications

enum NotificationManager {
    static func sendBudgetLimitNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Осторожно, бюджет на исходе!"
        content.body = "Вы уже израсходовали более 90% своего бюджета."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Ошибка при отправке уведомления: \(error)")
            }
        }
    }
}
