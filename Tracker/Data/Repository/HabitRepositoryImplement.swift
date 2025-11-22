
import Foundation

final class HabitRepositoryImplement: CreateHabitRepository, FetchHabitsRepository, UpdateHabitRepository, DeleteHabitRepository {

    private let dataSource: HabitDataSource
    
    init(dataSource: HabitDataSource) {
        self.dataSource = dataSource
    }
    
    func createHabit(habit: Habit) {
        dataSource.createHabit(habit: habit)
    }
    
    func fetchHabits(date: Date) -> [Habit] {
        dataSource.fetchHabits(date: date)
    }
    
    func deleteHabit(title: String) {
        dataSource.deleHabit(title: title)
    }
    
    func updateHabit(habitId: String, habit: Habit) {
        dataSource.updateHabit(habitId: habitId, habit: habit)
    }
}
