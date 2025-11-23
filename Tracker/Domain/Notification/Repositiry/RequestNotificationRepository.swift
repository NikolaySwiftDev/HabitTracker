
import Foundation
import UserNotifications

protocol RequestNotificationRepository: AnyObject {
    func requestNotificationPermission() async -> Bool
    func getNotificationStatus() async -> UNAuthorizationStatus
    func ensureNotificationPermission() async -> Bool
}
