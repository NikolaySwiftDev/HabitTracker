
import Foundation
import CoreData


protocol DailyProgressDataSource: AnyObject {
    func updateDailyProgress(dailyProgress: DailyProgress)
    
    func getDailyProgress() -> DailyProgress?
}
