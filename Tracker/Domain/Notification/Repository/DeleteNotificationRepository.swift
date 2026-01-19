
import Foundation

protocol DeleteNotificationRepository: AnyObject {
    func removeAllNotification(identifier: String)
    func removeNotificationFromDay(identifier: String) async throws
}
