
import Foundation

protocol NotificationDataSource: AnyObject {
    // MARK: - Permission Methods
    func requestNotificationPermission() async -> Bool
    func getNotificationStatus() async -> Bool

    // MARK: - Notification Creation
    func createDailyNotification(identifier: String, title: String, body: String, date: Date) async throws
    
    // MARK: - Notification Management
    func removeAllNotification(identifier: String)
    func removeNotificationFromDay(identifier: String) async
}
