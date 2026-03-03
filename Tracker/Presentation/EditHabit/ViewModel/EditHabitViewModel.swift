import Foundation
import Combine

final class EditHabitViewModel: ObservableObject {
    
    @Published var isNotificationIsAuthorized: Bool = false
    
    let habit: Habit
    
    private let editHabitUseCase: EditHabitUseCase
    private let requestNotificationUseCase: RequestNotificationUseCase
    private let deleteNotificationUseCase: DeleteNotificationUseCase
    private let createNotificationUseCase: CreateNotificationUseCase
    private let fetchHabitsUseCase: FetchHabitsUseCase
    
    init(habit: Habit,
         editHabitUseCase: EditHabitUseCase,
         requestNotificationUseCase: RequestNotificationUseCase,
         deleteNotificationUseCase: DeleteNotificationUseCase,
         createNotificationUseCase: CreateNotificationUseCase,
         fetchHabitsUseCase: FetchHabitsUseCase) {
        self.habit = habit
        self.editHabitUseCase = editHabitUseCase
        self.requestNotificationUseCase = requestNotificationUseCase
        self.deleteNotificationUseCase = deleteNotificationUseCase
        self.createNotificationUseCase = createNotificationUseCase
        self.fetchHabitsUseCase = fetchHabitsUseCase
    }
    
    func editHabit(newTitle: String, newEmoji: String, newNotificationTime: Date?, hasNotification: Bool) async throws {
        // Получаем все экземпляры этой привычки (все дни)
        let allHabitInstances = fetchAllHabitInstances()
        
        // Обновляем каждый экземпляр привычки
        for habitInstance in allHabitInstances {
            try await editHabitUseCase.execute(
                habit: habitInstance,
                newTitle: newTitle,
                newEmoji: newEmoji
            )
        }
        
        // Управление уведомлениями
        if hasNotification, let notificationTime = newNotificationTime {
            // Удаляем старые уведомления
            deleteNotificationUseCase.removeAllNotification(identifier: habit.habitsID.uuidString)
            
            // Создаём новые уведомления
            try await createNotificationUseCase.createDailyNotification(
                id: habit.habitsID,
                notificationTime: notificationTime,
                title: newTitle,
                daysCount: getTotalDaysCount(),
                startDate: getStartDate()
            )
        } else {
            // Если уведомления выключены - удаляем все
            deleteNotificationUseCase.removeAllNotification(identifier: habit.habitsID.uuidString)
        }
    }
    
    func getNotificationStatus() async {
        isNotificationIsAuthorized = await requestNotificationUseCase.requestNotificationPermission()
    }
    
    // MARK: - Private helpers
    
    private func fetchAllHabitInstances() -> [Habit] {
        let startDate = getStartDate()
        let totalDays = getTotalDaysCount()
        
        var allHabits: [Habit] = []
        
        for dayOffset in 0..<totalDays {
            if let habitDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: startDate) {
                let habits = fetchHabitsUseCase.execute(date: habitDate)
                let matchingHabits = habits.filter { $0.habitsID == habit.habitsID }
                allHabits.append(contentsOf: matchingHabits)
            }
        }
        
        return allHabits
    }
    
    private func getStartDate() -> Date {
        // Находим самую раннюю дату среди всех экземпляров
        let allHabits = fetchHabitsUseCase.execute(date: habit.createdAt)
        let matchingHabits = allHabits.filter { $0.habitsID == habit.habitsID && $0.dayCount == 0 }
        return matchingHabits.first?.createdAt ?? habit.createdAt
    }
    
    private func getTotalDaysCount() -> Int {
        // Находим максимальный dayCount + 1
        var maxDayCount = habit.dayCount
        let calendar = Calendar.current
        
        // Проверяем несколько дней вперёд от текущей даты привычки
        for offset in 0...30 {
            if let checkDate = calendar.date(byAdding: .day, value: offset, to: habit.createdAt) {
                let habits = fetchHabitsUseCase.execute(date: checkDate)
                let matchingHabits = habits.filter { $0.habitsID == habit.habitsID }
                for h in matchingHabits {
                    maxDayCount = max(maxDayCount, h.dayCount)
                }
            }
        }
        
        return maxDayCount + 1
    }
}
