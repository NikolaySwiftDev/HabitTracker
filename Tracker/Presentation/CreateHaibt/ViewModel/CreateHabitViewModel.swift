
import Foundation
import Combine

final class CreateHabitViewModel: ObservableObject {
    
    @Published var isNotificationIsAuthorized: Bool = false
    
    private let createHabitUseCase: CreateHabitUseCase
    private let requestNotificationUseCase: RequestNotificationUseCase
    private let createNotifiactionUseCase: CreateNotificationUseCase
    
    init(createHabitUseCase: CreateHabitUseCase,
         requestNotificationUseCase: RequestNotificationUseCase,
         createNotifiactionUseCase: CreateNotificationUseCase) {
        self.createHabitUseCase = createHabitUseCase
        self.requestNotificationUseCase = requestNotificationUseCase
        self.createNotifiactionUseCase = createNotifiactionUseCase
    }
    
    func createHabite(habitsID: UUID, title: String, emoji: String, startDate: Date, daysCount: Int) {
        createHabitUseCase.execute(habitsID: habitsID, title: title, emoji: emoji, startDate: startDate, daysCount: daysCount)
    }
    
    func createDailyNotification(id: UUID, title: String, notificationTime: Date, daysCount: Int, startDate: Date) async throws {
        try await createNotifiactionUseCase.createDailyNotification(id: id, notificationTime: notificationTime, title: title, daysCount: daysCount, startDate: startDate)
    }
    
    func getNotificationStatus() async {
        isNotificationIsAuthorized = await requestNotificationUseCase.requestNotificationPermission()
    }
}
