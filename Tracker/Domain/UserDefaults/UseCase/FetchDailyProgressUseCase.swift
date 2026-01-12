import Foundation

protocol FetchDailyProgressUseCase: AnyObject {
    func execute() -> DailyProgress?
}

final class FetchDailyProgressImplementation: FetchDailyProgressUseCase {
    
    private let repository: FetchDailyProgressRepository
    init(repository: FetchDailyProgressRepository) {
        self.repository = repository
    }
    
    func execute() -> DailyProgress? {
        repository.fetchDailyProgress()
    }
}

