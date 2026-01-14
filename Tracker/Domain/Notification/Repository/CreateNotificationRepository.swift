
import Foundation

protocol CreateNotificationRepository: AnyObject {
    func createDailyNotification(identifier: String, title: String, body: String, date: Date) async throws
}
