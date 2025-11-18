
import Foundation

protocol FetchHabitsRepository: AnyObject {
    func fetchHabits() -> [Habit]
}
