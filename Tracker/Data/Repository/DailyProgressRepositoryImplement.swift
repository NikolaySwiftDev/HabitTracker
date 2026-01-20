
import Foundation

final class DailyProgressRepositoryImplement: UpdateDailyProgressRepository, FetchDailyProgressRepository {

    let dataSource: DailyProgressDataSource
    
    init(dataSource: DailyProgressDataSource) {
        self.dataSource = dataSource
    }
    
    func updateDailyProgress(dailyProgress: DailyProgress) {
        dataSource.updateDailyProgress(dailyProgress: dailyProgress)
    }
    
    func getDailyProgress() -> DailyProgress? {
        dataSource.getDailyProgress()
    }
}
