
import Foundation

protocol UpdateHabitUseCase: AnyObject {
    func execute(habitId: String, habit: Habit, date: Date) async throws
}

final class UpdateHabitImplement: UpdateHabitUseCase {

    private let repository: UpdateHabitRepository
    private let calendar = Calendar.current

    init(repository: UpdateHabitRepository) {
        self.repository = repository
    }

    func execute(habitId: String, habit: Habit, date: Date) async throws {
        if date.dayOnly > Date().dayOnly {
            throw HabitError.futureDateNotAllowed
        }
        var newHabit = habit
        newHabit.isCompletedToday.toggle()
        repository.updateHabit(habitId: habit.id.uuidString, habit: newHabit)
    }


}

enum HabitError: Error {
    case futureDateNotAllowed
}
