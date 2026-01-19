
import Foundation
import CoreData


protocol DailyProgressReadableDataSource: AnyObject {
    func getDailyProgress() -> DailyProgress?
}

protocol DailyProgressWritableDataSource: AnyObject {
    func updateDailyProgress(dailyProgress: DailyProgress)
}

typealias DailyProgressDataSource =
    DailyProgressReadableDataSource & DailyProgressWritableDataSource
