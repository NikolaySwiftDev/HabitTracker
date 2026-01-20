
import Foundation

protocol FetchDailyProgressRepository: AnyObject {
    func getDailyProgress() -> DailyProgress?
}
