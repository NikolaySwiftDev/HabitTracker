
import Foundation

protocol RequestNotificationUseCase: AnyObject {
    func requestNotificationPermission() async -> Bool
    func getNotificationStatus() async -> Bool
}

final class RequestNotificationImplement: RequestNotificationUseCase {

    private let repository: RequestNotificationRepository
    
    init(repository: RequestNotificationRepository) {
        self.repository = repository
    }
    
    func requestNotificationPermission() async -> Bool {
        await repository.requestNotificationPermission()
    }
    
    func getNotificationStatus() async -> Bool {
        await repository.getNotificationStatus()
    }
}
