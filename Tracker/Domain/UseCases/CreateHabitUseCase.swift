import Foundation

protocol CreateHabitUseCase: AnyObject {
    func execute(habit: Habit)
}

final class CreateHabitImplement: CreateHabitUseCase {
    private let repository: CreateHabitRepository
    
    init(repository: CreateHabitRepository) {
        self.repository = repository
    }
    
    func execute(habit: Habit) {
        repository.createHabit(habit: habit)
    }
}
