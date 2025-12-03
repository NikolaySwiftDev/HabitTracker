

import Foundation
import Combine


final class HabitListViewModel: ObservableObject {
    
    @Published var habits: [Habit] = []
    
    private let deleteHabitUseCase: DeleteHabitUseCase
    private let fetchHabitsUseCase: FetchHabitsUseCase
    private let updateHabitUseCase: UpdateHabitUseCase
    
    private let requestNotificationUseCase: RequestNotificationUseCase
    private let deleteNotifiactionUseCase: DeleteNotificationUseCase

    
    init(deleteHabitUseCase: DeleteHabitUseCase,
         fetchHabitsUseCase: FetchHabitsUseCase,
         updateHabitUseCase: UpdateHabitUseCase,
         requestNotificationUseCase: RequestNotificationUseCase,
         deleteNotifiactionUseCase: DeleteNotificationUseCase,
    ) {
        self.deleteHabitUseCase = deleteHabitUseCase
        self.fetchHabitsUseCase = fetchHabitsUseCase
        self.updateHabitUseCase = updateHabitUseCase
        self.requestNotificationUseCase = requestNotificationUseCase
        self.deleteNotifiactionUseCase = deleteNotifiactionUseCase
    }
    
    func fetchHabits(date: Date) {
        habits = fetchHabitsUseCase.execute(date: date)
    }
    
    func deleteHabit(id: String) {
        deleteHabitUseCase.execute(id: id)
    }
    
    func updateHabit(habitId: String, habit: Habit) {
        updateHabitUseCase.execute(habitId: habitId, habit: habit)
    }
    
    func requestNotificationPersmission() async -> Bool {
        await requestNotificationUseCase.requestNotificationPermission()
    }
    
    func removeNotification(identifier: String) {
        deleteNotifiactionUseCase.removeNotification(identifier: identifier)
    }
}
