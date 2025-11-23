
import Foundation

protocol CreateNotificationRepository: AnyObject {
    func createDailyNotification(identifier: String, title: String, body: String, hour: Int, minute: Int) async throws
    func createDailyNotificationIfAuthorized(identifier: String, title: String, body: String, hour: Int, minute: Int) async -> Bool
}
