

import Foundation
import Combine


final class HabitListViewModel: ObservableObject {
    
    @Published var habits: [Habit] = []
    @Published var streak = 0
    @Published var isComleted = false
    @Published var datesComplete: Set<Date> = []
    
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
        fetchDailyProgress()
    }
    
    func deleteHabit(id: String, date: Date) {
        deleteHabitUseCase.execute(id: id)
        removeAllNotification(identifier: id)
        fetchHabits(date: date)
        if habits.isEmpty {
            clearDailyprogress()
        }
    }
    
    func updateHabit(habitId: String, habit: Habit, date: Date) async -> Bool {
        do {
            try await updateHabitUseCase.execute(habitId: habitId, habit: habit, date: date)
            fetchHabits(date: date)
            updateDailyprogress(date: date)
            return false
        } catch {
            return true
        }
    }
    
    func canUpdateHabit(for date: Date) -> Bool {
        date.dayOnly <= Date().dayOnly
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
    
    func removeAllNotification(identifier: String) {
        deleteNotifiactionUseCase.removeAllNotification(identifier: identifier)
    }
    
    func removeNotificationFromDay(identifier: String, day: Int) async {
        await deleteNotifiactionUseCase.removeNotificationFromDay(identifier: identifier, day: day)
    }
    
    //UserDef
    func fetchDailyProgress() {
        guard let model = fetchDailyProgressUseCase.execute() else { return }
        streak = model.streak
        isComleted = model.isComplete
        datesComplete = Set(
            model.datesComplete.map { $0.dayOnly }
        )
    }
    
    func updateDailyprogress(date: Date) {
        if checkIsAllHabitsComplete() && !datesComplete.contains(date.dayOnly) {
            updateDailyProgressUseCase.execute(isComplete: true, for: date.dayOnly)
        } else {
            if !checkIsAllHabitsComplete() && datesComplete.contains(date.dayOnly) {
                updateDailyProgressUseCase.execute(isComplete: false, for: date.dayOnly)
            }
        }
        fetchDailyProgress()
        print(datesComplete)
    }
    
    func clearDailyprogress() {
        updateDailyProgressUseCase.clearDailyprogress()
        fetchDailyProgress()
    }
}
