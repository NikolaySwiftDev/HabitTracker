import Foundation

protocol FetchHabitsUseCase: AnyObject {
    func execute() -> [Habit]
}

final class FetchHabitsImplement: FetchHabitsUseCase {
    private let repository: FetchHabitsRepository
    
    init(repository: FetchHabitsRepository) {
        self.repository = repository
    }
    
    func execute() -> [Habit] {
        repository.fetchHabits()
    }
}
