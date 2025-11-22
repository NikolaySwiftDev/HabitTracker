
import Foundation

protocol DeleteHabitUseCase: AnyObject {
    func execute(title: String)
}

final class DeleteHabitImplement: DeleteHabitUseCase {
    private let repository: DeleteHabitRepository
    
    init(repository: DeleteHabitRepository) {
        self.repository = repository
    }
    
    func execute(title: String) {
        repository.deleteHabit(title: title)
    }
}
