
import Foundation

protocol FetchHabitsRepository: AnyObject {
    func fetchHabits(date: Date) -> [Habit]
}
