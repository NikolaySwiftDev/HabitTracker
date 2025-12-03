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
    func createDailyNotification(identifier: String, title: String, body: String, hour: Int, minute: Int) async throws {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .defaultRingtone
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // Создаем запрос
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
        
        // Добавляем запрос в центр уведомлений
        try await center.add(request)
        print("Daily notification scheduled for \(hour):\(minute)")
    }
    
    // MARK: - Remove Notification
    func removeNotification(identifier: String) {
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
        print("Notification with identifier \(identifier) removed")
    }
    
    // MARK: - Remove All Notifications
    func removeAllNotifications() {
        center.removeAllPendingNotificationRequests()
        print("All notifications removed")
    }
}
