
import Foundation

protocol DeleteNotificationUseCase: AnyObject {
    func execute()
}

final class DeleteNotificationImplement: DeleteNotificationUseCase {
 
    private let repository: DeleteNotificationRepository
    
    init(repository: DeleteNotificationRepository) {
        self.repository = repository
    }
    
    func execute() {
        repository.deleteotification()
    }
}
