
import Foundation
import CoreData

final class CoreDataManager: HabitDataSource {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func createHabit(habit: Habit) {
        let savedHabit = HabitMapper.toEntety(habit: habit, context: context)
        try? context.save()
    }
    
    func fetchHabits() -> [Habit] {
        let request = HabitEntities.fetchRequest()
        if let habits = try? context.fetch(request) {
            let habitDomain = habits.map {
                HabitMapper.toDomain(entity: $0)
            }
            return habitDomain
        }
        return []
    }
    
    func updateHabit(habitId: String, habit: Habit) {
        let request = HabitEntities.fetchRequest()
        request.predicate = NSPredicate(format: "id == $@", habitId)
        
        if let habits = try? context.fetch(request), !habits.isEmpty, let resultHabit = habits.first {
            resultHabit.title = habit.title
            resultHabit.body = habit.body
            resultHabit.colorHex = habit.colorHex
            resultHabit.createdAt = habit.createdAt
            resultHabit.id = habit.id
            resultHabit.isCompletedToday = habit.isCompletedToday
            resultHabit.streak = habit.streak
            try? context.save()
        }
    }
    
    func deleHabit(habitId: String) {
        let request = HabitEntities.fetchRequest()
        request.predicate = NSPredicate(format: "id == $@", habitId)
        
        if let habit = try? context.fetch(request), !habit.isEmpty, let resultHabit = habit.first {
            context.delete(resultHabit)
        }
    }
}
