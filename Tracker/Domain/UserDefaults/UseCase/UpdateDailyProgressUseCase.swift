import Foundation

protocol UpdateDailyProgressUseCase: AnyObject {
    func execute(isComplete: Bool, for date: Date)
    func clearDailyprogress()
}

final class UpdateDailyProgressImplementation: UpdateDailyProgressUseCase {
    
    private let fetchRepository: FetchDailyProgressRepository
    private let updateRepository: UpdateDailyProgressRepository
    private let calendar: Calendar
    
    init(fetchRepository: FetchDailyProgressRepository,
         updateRepository: UpdateDailyProgressRepository,
         calendar: Calendar = .current) {
        self.fetchRepository = fetchRepository
        self.updateRepository = updateRepository
        self.calendar = calendar
    }
    
    func execute(isComplete: Bool, for date: Date) {
        guard var model = fetchRepository.fetchDailyProgress() else {
            var newModel = DailyProgress(lastCompleteDate: nil, streak: 0, isComplete: false)
            uptadeModel(&newModel, isComplete: isComplete)
            updateRepository.updateDailyProgress(dailyProgress: newModel)
            return
        }
        uptadeModel(&model, isComplete: isComplete)
        updateRepository.updateDailyProgress(dailyProgress: model)
    }
    
    func clearDailyprogress() {
        let newModel = DailyProgress(lastCompleteDate: nil, streak: 0, isComplete: false)
        updateRepository.updateDailyProgress(dailyProgress: newModel)
    }
    
    private func uptadeModel( _ model: inout DailyProgress, isComplete: Bool) {
        if isComplete {
            model.streak += 1
        } else {
            model.streak -= 1
        }
        model.isComplete = isComplete
        
        print("Model streak", model.streak)
        print("Model isComplete", model.isComplete)
    }
}
