
import Foundation
import UserNotifications

protocol NotificationDataSource: AnyObject {
    // MARK: - Permission Methods
    func requestNotificationPermission() async -> Bool
    func getNotificationStatus() async -> UNAuthorizationStatus
    func ensureNotificationPermission() async -> Bool
    
    // MARK: - Notification Creation
    func createDailyNotification(identifier: String, title: String, body: String, hour: Int, minute: Int) async throws
    func createDailyNotificationIfAuthorized(identifier: String, title: String, body: String, hour: Int, minute: Int) async -> Bool
    
    // MARK: - Notification Management
    func removeNotification(identifier: String)
    func removeAllNotifications()
}
