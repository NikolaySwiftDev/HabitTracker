
import Foundation

protocol RequestNotificationRepository: AnyObject {
    func requestNotificationPermission() async -> Bool
    func getNotificationStatus() async -> Bool
}
