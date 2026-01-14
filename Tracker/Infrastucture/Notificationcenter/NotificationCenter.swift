import Foundation
import UserNotifications

final class NotificationManager: NotificationDataSource {
    
    private let center = UNUserNotificationCenter.current()
    
    // MARK: - Request Permission
    func requestNotificationPermission() async -> Bool {
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            print("Notification permission granted: \(granted)")
            return granted
        } catch {
            print("Error requesting notification permission: \(error)")
            return false
        }
    }
    
    // MARK: - Check Current Permission Status
    func getNotificationStatus() async -> Bool {
        let settings =  await center.notificationSettings()
        switch settings.authorizationStatus {
        case .notDetermined:
           return false
        case .denied:
            return false
        case .authorized:
            return true
        case .provisional:
            return true
        case .ephemeral:
            return true
        @unknown default:
            return false
        }
    }
    
    // MARK: - Create Daily Notification
    func createDailyNotification(identifier: String, title: String, body: String, date: Date) async throws {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .defaultRingtone
        
        guard date > Date() else { return }

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents(
                [.year, .month, .day, .hour, .minute],
                from: date
            ),
            repeats: false
        )
        
        // Создаем запрос
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
        
        // Добавляем запрос в центр уведомлений
        try await center.add(request)
        print("Daily notification scheduled for \(trigger.dateComponents.hour):\(trigger.dateComponents.minute)")
    }
    
    // MARK: - Remove Notification
    func removeNotification(identifier: String) {
        center.getPendingNotificationRequests { [weak self] requests in
            guard let self = self else { return }
            // Фильтруем только те идентификаторы, которые начинаются с id
            let identifiersToRemove = requests
                .map { $0.identifier }
                .filter { $0.hasPrefix(identifier) }
            
            // Удаляем все pending и доставленные уведомления
            center.removePendingNotificationRequests(withIdentifiers: identifiersToRemove)
            center.removeDeliveredNotifications(withIdentifiers: identifiersToRemove)
            
            print("Removed notifications: \(identifiersToRemove)")
        }
    }
    
    // MARK: - Remove All Notifications
//    func removeAllNotifications() {
//        center.removeAllPendingNotificationRequests()
//        print("All notifications removed")
//    }
}
