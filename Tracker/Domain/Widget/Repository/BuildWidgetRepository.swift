
import Foundation

protocol BuildWidgetSnapshotRepository: AnyObject {
    func execute() -> WidgetHabitSnapshot?
}
