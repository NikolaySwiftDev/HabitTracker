
import Foundation
import UserNotifications

protocol RequestNotificationUseCase: AnyObject {
    func requestNotificationPermission() async -> Bool
    func getNotificationStatus() async -> UNAuthorizationStatus
    func ensureNotificationPermission() async -> Bool
}

final class RequestNotificationImplement: RequestNotificationUseCase {

    private let repository: RequestNotificationRepository
    
    init(repository: RequestNotificationRepository) {
        self.repository = repository
    }
    
    func requestNotificationPermission() async -> Bool {
        await repository.requestNotificationPermission()
    }
    
    func getNotificationStatus() async -> UNAuthorizationStatus {
        await repository.getNotificationStatus()
    }
    
    func ensureNotificationPermission() async -> Bool {
        await repository.ensureNotificationPermission()
    }

}
