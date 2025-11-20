
import Foundation
import CoreData


struct Assembly {
    static func createHabitListViewModel() -> HabitListViewModel {
        
        let context = PersistaintController()
        let dataSource = CoreDataManager(context: context.persistentContainer.viewContext)
        let repository = HabitRepositoryImplement(dataSource: dataSource)
        
        let deleteHabitUseCase = DeleteHabitImplement(repository: repository)
        let fetchHabitsUseCase = FetchHabitsImplement(repository: repository)
        let updateHabitsUseCase = UpdateHabitImplement(repository: repository)
        let createHabitsUseCase = CreateHabitImplement(repository: repository)

        let viewModel = HabitListViewModel(deleteHabitUseCase: deleteHabitUseCase,
                                           fetchHabitsUseCase: fetchHabitsUseCase,
                                           updateHabitUseCase: updateHabitsUseCase,
                                           createHabitUseCase: createHabitsUseCase)
        
        return viewModel
    }
}
