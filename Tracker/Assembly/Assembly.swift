
import Foundation
import CoreData


struct Assembly {
    static func createHabitListViewModel() -> HabitListViewModel {
        
        //Habit Core Data
        let context = PersistaintController()
        let dataSource = CoreDataManager(context: context.persistentContainer.viewContext)
        let repository = HabitRepositoryImplement(dataSource: dataSource)
        
        let deleteHabitUseCase = DeleteHabitImplement(repository: repository)
        let fetchHabitsUseCase = FetchHabitsImplement(repository: repository)
        let updateHabitsUseCase = UpdateHabitImplement(repository: repository)
        
        //Notification
        let notificationDataSource = NotificationManager()
        let notificationDataSourceRepository = NotificationRepositoryImplement(dataSource: notificationDataSource)
        let requestNotificationUseCase = RequestNotificationImplement(repository: notificationDataSourceRepository)
        let deleteNotificationUseCase = DeleteNotificationImplement(repository: notificationDataSourceRepository)
        
        //User Defaults
        let userDefDataSource = UserDefaultsManager()
        let userDefDataSourceRepository = DailyProgressRepositoryImplement(dataSource: userDefDataSource)
        let updateDefDataUseCase = UpdateDailyProgressImplementation(fetchRepository: userDefDataSourceRepository, updateRepository: userDefDataSourceRepository)
        let fetchDefDataUseCase = FetchDailyProgressImplementation(repository: userDefDataSourceRepository)

        //View Model
        let viewModel = HabitListViewModel(deleteHabitUseCase: deleteHabitUseCase,
                                           fetchHabitsUseCase: fetchHabitsUseCase,
                                           updateHabitUseCase: updateHabitsUseCase,
                                           updateDailyProgress: updateDefDataUseCase,
                                           fetchDailyProgress: fetchDefDataUseCase,
                                           requestNotificationUseCase: requestNotificationUseCase,
                                           deleteNotifiactionUseCase: deleteNotificationUseCase
                                          
        )
        
        return viewModel
    }
    
    static func createCreateHabitViewModel() -> CreateHabitViewModel {
        
        //Core Data
        let context = PersistaintController()
        let dataSource = CoreDataManager(context: context.persistentContainer.viewContext)
        let repository = HabitRepositoryImplement(dataSource: dataSource)
        let createHabitsUseCase = CreateHabitImplement(repository: repository)
        
        //Notification
        let notificationDataSource = NotificationManager()
        let notificationDataSourceRepository = NotificationRepositoryImplement(dataSource: notificationDataSource)
        let createNotifcationUseCase = CreateNotificationImplement(repository: notificationDataSourceRepository)
        let requestNotificationUseCase = RequestNotificationImplement(repository: notificationDataSourceRepository)

        
        //View Model
        let viewModel = CreateHabitViewModel(createHabitUseCase: createHabitsUseCase,
                                             requestNotificationUseCase: requestNotificationUseCase,
                                             createNotifiactionUseCase: createNotifcationUseCase)
        
        return viewModel
    }
    
    static func createEditHabitViewModel(for habit: Habit) -> EditHabitViewModel {
        
        //Core Data
        let context = PersistaintController()
        let dataSource = CoreDataManager(context: context.persistentContainer.viewContext)
        let repository = HabitRepositoryImplement(dataSource: dataSource)
        
        let editHabitUseCase = EditHabitImplement(repository: repository)
        let fetchHabitsUseCase = FetchHabitsImplement(repository: repository)
        
        //Notification
        let notificationDataSource = NotificationManager()
        let notificationDataSourceRepository = NotificationRepositoryImplement(dataSource: notificationDataSource)
        let requestNotificationUseCase = RequestNotificationImplement(repository: notificationDataSourceRepository)
        let deleteNotificationUseCase = DeleteNotificationImplement(repository: notificationDataSourceRepository)
        let createNotificationUseCase = CreateNotificationImplement(repository: notificationDataSourceRepository)
        
        //View Model
        let viewModel = EditHabitViewModel(
            habit: habit,
            editHabitUseCase: editHabitUseCase,
            requestNotificationUseCase: requestNotificationUseCase,
            deleteNotificationUseCase: deleteNotificationUseCase,
            createNotificationUseCase: createNotificationUseCase,
            fetchHabitsUseCase: fetchHabitsUseCase
        )
        
        return viewModel
    }
}


