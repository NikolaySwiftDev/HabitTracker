import Foundation

protocol FetchHabitsUseCase: AnyObject {
    func execute(date: Date) -> [Habit]
}

final class FetchHabitsImplement: FetchHabitsUseCase {
    private let repository: FetchHabitsRepository
    
    init(repository: FetchHabitsRepository) {
        self.repository = repository
    }
    
    func execute(date: Date) -> [Habit] {
        repository.fetchHabits(date: date)
    }
}
