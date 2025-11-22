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
    func getNotificationStatus() async -> UNAuthorizationStatus {
        let settings = await center.notificationSettings()
        return settings.authorizationStatus
    }
    
    // MARK: - Create Daily Notification
    func createDailyNotification(identifier: String, title: String, body: String, hour: Int, minute: Int) async throws {
        // Создаем контент уведомления
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        // Создаем триггер на определенное время каждый день
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
    
    // MARK: - Convenience Methods
    
    /// Проверяет статус разрешений и запрашивает их если нужно
    func ensureNotificationPermission() async -> Bool {
        let status = await getNotificationStatus()
        
        switch status {
        case .authorized, .provisional, .ephemeral:
            return true
        case .denied:
            return false
        case .notDetermined:
            return await requestNotificationPermission()
        @unknown default:
            return await requestNotificationPermission()
        }
    }
    
    /// Создает ежедневное уведомление только если есть разрешение
    func createDailyNotificationIfAuthorized(identifier: String, title: String, body: String, hour: Int, minute: Int) async -> Bool {
        guard await ensureNotificationPermission() else {
            print("Cannot create notification: permission denied")
            return false
        }
        
        do {
            try await createDailyNotification(
                identifier: identifier,
                title: title,
                body: body,
                hour: hour,
                minute: minute
            )
            return true
        } catch {
            print("Failed to create daily notification: \(error)")
            return false
        }
    }
}
