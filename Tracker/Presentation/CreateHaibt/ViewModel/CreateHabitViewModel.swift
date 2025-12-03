
import Foundation
import Combine

final class CreateHabitViewModel: ObservableObject {
    
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
    
    func createHabit(habit: Habit) {
        createHabitUseCase.execute(habit: habit)
    }
    
    func createDailyNotification(identifier: String, title: String, body: String, hour: Int, minute: Int) async throws {
        try await createNotifiactionUseCase.createDailyNotification(identifier: identifier, title: title, body: body, hour: hour, minute: minute)
    }
    
    func getNotificationStatus() async -> Bool {
        await requestNotificationUseCase.requestNotificationPermission()
    }
}
