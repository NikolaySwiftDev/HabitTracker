
import Foundation

protocol DeleteHabitUseCase: AnyObject {
    func execute(id: String)
}

final class DeleteHabitImplement: DeleteHabitUseCase {
    private let repository: DeleteHabitRepository
    
    init(repository: DeleteHabitRepository) {
        self.repository = repository
    }
    
    func execute(id: String) {
        repository.deleteHabit(id: id)
    }
}
