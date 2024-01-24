//
//  Notifications.swift
//  dvdtheque
//
//  Created by loic lefebvre on 24/01/2024.
//

import Foundation
import UserNotifications

class Notifications {
    
    func createNotification(loan: Loan) {
        removeNotification(loanId: loan.id)
        if let reminder = loan.reminder {
            let content = UNMutableNotificationContent()
            content.title = (loan.type == "BORROW" ? "notification.borrow.message" : "notification.loan.message").localized(arguments: loan.box.title, loan.contact)
            content.sound = UNNotificationSound.default

            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date(timeIntervalSince1970: TimeInterval(reminder)))
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

            let request = UNNotificationRequest(identifier: "loan_notification_\(loan.id)", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    func removeNotification(loanId: Int) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["loan_notification_\(loanId)"])
    }
    
    func notificationPermissions() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            return false
        }
    }
}
