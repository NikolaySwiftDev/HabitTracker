

import Foundation
import UserNotifications

final class NotificationRepositoryImplement: RequestNotificationRepository, DeleteNotificationRepository, CreateNotificationRepository {
    
    private let dataSource: NotificationDataSource
    
    init(dataSource: NotificationDataSource) {
        self.dataSource = dataSource
    }
    
    func requestNotificationPermission() async -> Bool {
        await dataSource.requestNotificationPermission()
    }
    
    func getNotificationStatus() async -> UNAuthorizationStatus {
        await dataSource.getNotificationStatus()
    }
    
//    func ensureNotificationPermission() async -> Bool {
//        await dataSource.ensureNotificationPermission()
//    }
    
    func removeNotification(identifier: String) {
        dataSource.removeNotification(identifier: identifier)
    }
    
    func createDailyNotification(identifier: String, title: String, body: String, hour: Int, minute: Int) async throws {
        try await dataSource.createDailyNotification(identifier: identifier, title: title, body: body, hour: hour, minute: minute)
    }
    
//    func createDailyNotificationIfAuthorized(identifier: String, title: String, body: String, hour: Int, minute: Int) async -> Bool {
//       await ((try? dataSource.createDailyNotificationIfAuthorized(identifier: identifier, title: title, body: body, hour: hour, minute: minute)) != nil)
//    }
    
}
