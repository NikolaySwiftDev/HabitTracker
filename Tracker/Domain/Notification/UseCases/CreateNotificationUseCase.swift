
import Foundation

protocol CreateNotificationUseCase: AnyObject {
    func createDailyNotification(id: UUID, notificationTime: Date, title: String, daysCount: Int, startDate: Date) async throws
}

final class CreateNotificationImplement: CreateNotificationUseCase {
     
    private let repository: CreateNotificationRepository
    
    init(repository: CreateNotificationRepository) {
        self.repository = repository
    }
    
    func createDailyNotification(id: UUID, notificationTime: Date, title: String, daysCount: Int, startDate: Date) async throws {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: notificationTime)
        let minute = calendar.component(.minute, from: notificationTime)
        
        for dayOffset in 0..<daysCount {
            guard let dayDate = calendar.date(byAdding: .day, value: dayOffset, to: startDate) else { continue }
            guard let notificationDate = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: dayDate) else { continue }
            
            // Уникальный идентификатор для каждого дня
            let identifier = "\(id.uuidString)_\(dayOffset)"
            print(identifier)
            
            let body = "Do habit - \(title)"
            
            // Проверяем, что дата в будущем
            guard notificationDate > Date() else { continue }
            
            try await repository.createDailyNotification(
                identifier: identifier,
                title: title,
                body: body,
                date: notificationDate
            )
        }
    }
}
