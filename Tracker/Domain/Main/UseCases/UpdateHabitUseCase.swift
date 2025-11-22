
import Foundation

protocol UpdateHabitUseCase: AnyObject {
    func execute(habitId: String, habit: Habit)
}

final class UpdateHabitImplement: UpdateHabitUseCase {
    private let repository: UpdateHabitRepository
    
    init(repository: UpdateHabitRepository) {
        self.repository = repository
    }
    
    func execute(habitId: String, habit: Habit) {
        repository.updateHabit(habitId: habitId, habit: habit)
    }
}
