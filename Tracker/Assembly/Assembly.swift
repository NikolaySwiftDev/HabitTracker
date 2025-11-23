
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

        let viewModel = HabitListViewModel(deleteHabitUseCase: deleteHabitUseCase,
                                           fetchHabitsUseCase: fetchHabitsUseCase,
                                           updateHabitUseCase: updateHabitsUseCase)
        
        return viewModel
    }
    
    static func createCreateHabitViewModel() -> CreateHabitViewModel {
        
        let context = PersistaintController()
        let dataSource = CoreDataManager(context: context.persistentContainer.viewContext)
        let repository = HabitRepositoryImplement(dataSource: dataSource)
        let createHabitsUseCase = CreateHabitImplement(repository: repository)
        
        let notificationDataSource = NotificationManager()
        let notificationDataSourceRepository = NotificationRepositoryImplement(dataSource: notificationDataSource)
        
        let requestNotificationUseCase = RequestNotificationImplement(repository: notificationDataSourceRepository)
        let deleteNotificationUseCase = DeleteNotificationImplement(repository: notificationDataSourceRepository)
        let createNotifcationUseCase = CreateNotificationImplement(repository: notificationDataSourceRepository)
        
        let viewModel = CreateHabitViewModel(createHabitUseCase: createHabitsUseCase,
                                             requestNotificationUseCase: requestNotificationUseCase,
                                             deleteNotifiactionUseCase: deleteNotificationUseCase,
                                             createNotifiactionUseCase: createNotifcationUseCase)
        
        return viewModel
    }
}
