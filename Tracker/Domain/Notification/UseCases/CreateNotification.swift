
import Foundation

protocol CreateNotificationUseCase: AnyObject {
    func execute()
}

final class CreateNotificationImplement: CreateNotificationUseCase {
 
    private let repository: CreateNotificationRepository
    
    init(repository: CreateNotificationRepository) {
        self.repository = repository
    }
    
    func execute() {
        repository.createNotification()
    }
    
    
}
