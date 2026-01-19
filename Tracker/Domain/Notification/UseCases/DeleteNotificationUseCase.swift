
import Foundation

protocol DeleteNotificationUseCase: AnyObject {
    func removeAllNotification(identifier: String)
    func removeNotificationFromDay(identifier: String, day: Int) async
}

final class DeleteNotificationImplement: DeleteNotificationUseCase {
  
    private let repository: DeleteNotificationRepository
    
    init(repository: DeleteNotificationRepository) {
        self.repository = repository
    }
    
    func removeAllNotification(identifier: String) {
        repository.removeAllNotification(identifier: identifier)
    }
    
    func removeNotificationFromDay(identifier: String, day: Int) async {
        let newID = "\(identifier)_\(day)"
        try? await repository.removeNotificationFromDay(identifier: newID)
    }

}
