

import Foundation

final class NotificationRepositoryImplement: RequestNotificationRepository, DeleteNotificationRepository, CreateNotificationRepository {
    
    private let dataSource: NotificationDataSource
    
    init(dataSource: NotificationDataSource) {
        self.dataSource = dataSource
    }
    
    func requestNotificationPermission() async -> Bool {
        await dataSource.requestNotificationPermission()
    }
    
    func getNotificationStatus() async -> Bool {
        await dataSource.getNotificationStatus()
    }
    
    func removeNotification(identifier: String) {
        dataSource.removeNotification(identifier: identifier)
    }
    
    func createDailyNotification(identifier: String, title: String, body: String, date: Date) async throws {
        try await dataSource.createDailyNotification(identifier: identifier, title: title, body: body, date: date)
    }
}
