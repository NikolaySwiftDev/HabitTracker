

import Foundation

struct DailyProgressMapper {
    static func toWidgetHabitSnapshot(from model: DailyProgress) -> WidgetHabitSnapshot {
        let snapshot = WidgetHabitSnapshot(isCompletedToday: model.isComplete, streak: model.streak)
        return snapshot
    }
}
