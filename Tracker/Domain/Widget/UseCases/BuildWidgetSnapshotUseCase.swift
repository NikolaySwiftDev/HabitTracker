import WidgetKit

protocol BuildWidgetSnapshotUseCase: AnyObject {
    func getDailyProgress() -> WidgetHabitSnapshot?
}

final class BuildWidgetSnapshotImplementation: BuildWidgetSnapshotUseCase {
    
    private let repository: BuildWidgetSnapshotRepository
    
    init(repository: BuildWidgetSnapshotRepository) {
        self.repository = repository
    }
    
    func getDailyProgress() -> WidgetHabitSnapshot? {
        repository.execute()
    }
    
}
