
import Foundation

protocol CreateNotificationUseCase: AnyObject {
    func createDailyNotification(identifier: String, title: String, body: String, hour: Int, minute: Int) async throws
}

final class CreateNotificationImplement: CreateNotificationUseCase {
     
    private let repository: CreateNotificationRepository
    
    init(repository: CreateNotificationRepository) {
        self.repository = repository
    }
    
    func createDailyNotification(identifier: String, title: String, body: String, hour: Int, minute: Int) async throws {
        try? await repository.createDailyNotification(identifier: identifier, title: title, body: body, hour: hour, minute: minute)
    }
}
