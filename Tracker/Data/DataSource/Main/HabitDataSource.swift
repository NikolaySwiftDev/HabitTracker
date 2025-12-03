
import Foundation

protocol HabitDataSource: AnyObject {
    func createHabit(habit: Habit)
    func fetchHabits(date: Date) -> [Habit]
    func updateHabit(habitId: String, habit: Habit)
    func deleHabit(id: String)
}
