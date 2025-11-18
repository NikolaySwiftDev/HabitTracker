
import Foundation

final class HabitRepositoryImplement: CreateHabitRepository, FetchHabitsRepository, UpdateHabitRepository, DeleteHabitRepository {

    private let dataSource: HabitDataSource
    init(dataSource: HabitDataSource) {
        self.dataSource = dataSource
    }
    
    func createHabit(habit: Habit) {
        dataSource.createHabit(habit: habit)
    }
    
    func fetchHabits() -> [Habit] {
        dataSource.fetchHabits()
    }
    
    func deleteHabit(habitId: String) {
        dataSource.deleHabit(habitId: habitId)
    }
    
    func updateHabit(habitId: String, habit: Habit) {
        dataSource.updateHabit(habitId: habitId, habit: habit)
    }
}
