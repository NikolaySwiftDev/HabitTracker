
import Foundation

protocol DeleteNotificationUseCase: AnyObject {
    func removeNotification(identifier: String)
//    func removeAllNotifications()
}

final class DeleteNotificationImplement: DeleteNotificationUseCase {
  
    private let repository: DeleteNotificationRepository
    
    init(repository: DeleteNotificationRepository) {
        self.repository = repository
    }
    
    func removeNotification(identifier: String) {
        repository.removeNotification(identifier: identifier)
    }
    
//    func removeAllNotifications() {
//        repository.removeAllNotifications()
//    }

}
