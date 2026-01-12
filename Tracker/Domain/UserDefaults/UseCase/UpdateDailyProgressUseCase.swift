
import Foundation

protocol UpdateDailyProgressUseCase: AnyObject {
    func execute(dailyProgress: DailyProgress)
}

final class UpdateDailyProgressImplementation: UpdateDailyProgressUseCase {
    
    private let repository: UpdateDailyProgressRepository
    init(repository: UpdateDailyProgressRepository) {
        self.repository = repository
    }
    
    func execute(dailyProgress: DailyProgress) {
        repository.updateDailyProgress(dailyProgress: dailyProgress)
    }
}
