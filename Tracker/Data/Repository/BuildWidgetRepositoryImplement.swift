
import Foundation

final class BuildWidgetRepositoryImplement: BuildWidgetSnapshotRepository {

    private let dataSource: DailyProgressReadableDataSource

    init(dataSource: DailyProgressReadableDataSource) {
        self.dataSource = dataSource
    }

    func execute() -> WidgetHabitSnapshot? {
        guard let progress = dataSource.getDailyProgress() else {
            return nil
        }

        return WidgetHabitSnapshot(isCompletedToday: progress.isComplete, streak: progress.streak)
    }
}
