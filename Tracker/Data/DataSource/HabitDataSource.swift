
import Foundation

protocol HabitDataSource: AnyObject {
    func createHabit(habit: Habit)
    func fetchHabits() -> [Habit]
    func updateHabit(habitId: String, habit: Habit)
    func deleHabit(habitId: String)
}
