

import Foundation
import Combine


final class HabitListViewModel: ObservableObject {
    
    @Published var habits: [Habit] = []
    @Published var streak = 0
    @Published var isComleted = false
    
    //Core Data
    private let deleteHabitUseCase: DeleteHabitUseCase
    private let fetchHabitsUseCase: FetchHabitsUseCase
    private let updateHabitUseCase: UpdateHabitUseCase
    
    //User Defaults
    private let updateDailyProgressUseCase: UpdateDailyProgressUseCase
    private let fetchDailyProgressUseCase: FetchDailyProgressUseCase
    
    //User Defaults
    private let requestNotificationUseCase: RequestNotificationUseCase
    private let deleteNotifiactionUseCase: DeleteNotificationUseCase

    
    init(deleteHabitUseCase: DeleteHabitUseCase,
         fetchHabitsUseCase: FetchHabitsUseCase,
         updateHabitUseCase: UpdateHabitUseCase,
         updateDailyProgress: UpdateDailyProgressUseCase,
         fetchDailyProgress: FetchDailyProgressUseCase,
         requestNotificationUseCase: RequestNotificationUseCase,
         deleteNotifiactionUseCase: DeleteNotificationUseCase) {
        self.deleteHabitUseCase = deleteHabitUseCase
        self.fetchHabitsUseCase = fetchHabitsUseCase
        self.updateHabitUseCase = updateHabitUseCase
        self.updateDailyProgressUseCase = updateDailyProgress
        self.fetchDailyProgressUseCase = fetchDailyProgress
        self.requestNotificationUseCase = requestNotificationUseCase
        self.deleteNotifiactionUseCase = deleteNotifiactionUseCase
    }
    
    //Core Data
    func fetchHabits(date: Date) {
        habits = fetchHabitsUseCase.execute(date: date)
    }
    
    func deleteHabit(id: String) {
        deleteHabitUseCase.execute(id: id)
    }
    
    func updateHabit(habitId: String, habit: Habit) {
        updateHabitUseCase.execute(habitId: habitId, habit: habit)
    }
        
    func checkIsAllHabitsComplete() -> Bool {
        habits.allSatisfy { $0.isCompletedToday }
    }
    
    func checkCountsIsAllHabitsComplete() -> Int {
        habits.filter { !$0.isCompletedToday }.count
    }
    
    //Nofit
    func requestNotificationPersmission() async -> Bool {
        await requestNotificationUseCase.requestNotificationPermission()
    }
    
    func removeNotification(identifier: String) {
        deleteNotifiactionUseCase.removeNotification(identifier: identifier)
    }
    
    //UserDef
    func fetchDailyProgress() {
        guard let model = fetchDailyProgressUseCase.execute() else { return }
        streak = model.streak
        isComleted = model.isComplete
    }
    
    func updateDailyprogress(isComplete: Bool, date: Date) {
        updateDailyProgressUseCase.execute(isComplete: isComplete, for: date)
        fetchDailyProgress()
    }
    
    func clearDailyprogress() {
        updateDailyProgressUseCase.clearDailyprogress()
        fetchDailyProgress()
    }
}
