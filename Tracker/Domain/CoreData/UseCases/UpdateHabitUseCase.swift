
import Foundation

protocol UpdateHabitUseCase: AnyObject {
    func execute(habitId: String, habit: Habit)
}

final class UpdateHabitImplement: UpdateHabitUseCase {

    private let repository: UpdateHabitRepository
    private let calendar = Calendar.current

    init(repository: UpdateHabitRepository) {
        self.repository = repository
    }

    func execute(habitId: String, habit: Habit) {
        var newHabit = habit
        newHabit.isCompletedToday.toggle()
        repository.updateHabit(habitId: habit.id.uuidString, habit: newHabit)
    }


}
