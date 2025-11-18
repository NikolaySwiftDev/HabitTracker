
import Foundation

protocol DeleteHabitUseCase: AnyObject {
    func execute(habitId: String)
}

final class DeleteHabitImplement: DeleteHabitUseCase {
    private let repository: DeleteHabitRepository
    
    init(repository: DeleteHabitRepository) {
        self.repository = repository
    }
    
    func execute(habitId: String) {
        repository.deleteHabit(habitId: habitId)
    }
}
