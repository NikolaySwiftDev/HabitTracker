

import Foundation

protocol UpdateHabitRepository: AnyObject {
    func updateHabit(habitId: String, habit: Habit)
}
