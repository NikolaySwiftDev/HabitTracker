
import Foundation
import Combine

final class CreateHabitViewModel: ObservableObject {
    
    private let createHabitUseCase: CreateHabitUseCase
    private let requestNotificationUseCase: RequestNotificationUseCase
    private let deleteNotifiactionUseCase: DeleteNotificationUseCase
    private let createNotifiactionUseCase: CreateNotificationUseCase
    
    init(createHabitUseCase: CreateHabitUseCase, requestNotificationUseCase: RequestNotificationUseCase, deleteNotifiactionUseCase: DeleteNotificationUseCase, createNotifiactionUseCase: CreateNotificationUseCase) {
        self.createHabitUseCase = createHabitUseCase
        self.requestNotificationUseCase = requestNotificationUseCase
        self.deleteNotifiactionUseCase = deleteNotifiactionUseCase
        self.createNotifiactionUseCase = createNotifiactionUseCase
    }
    
    func createHabit(habit: Habit) {
        createHabitUseCase.execute(habit: habit)
    }
    
    func requestNotificationPersmission() async -> Bool {
        await requestNotificationUseCase.requestNotificationPermission()
    }
    
    func removeNotification(identifier: String) {
        deleteNotifiactionUseCase.removeNotification(identifier: identifier)
        
    }
    
    func createDailyNotification(identifier: String, title: String, body: String, hour: Int, minute: Int) async throws {
        try await createNotifiactionUseCase.createDailyNotification(identifier: identifier, title: title, body: body, hour: hour, minute: minute)
    }
    
}
