
import Foundation

protocol FetchDailyProgressRepository: AnyObject {
    func fetchDailyProgress() -> DailyProgress?
}
