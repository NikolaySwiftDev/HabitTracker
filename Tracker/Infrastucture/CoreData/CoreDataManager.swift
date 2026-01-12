
import Foundation
import CoreData

final class CoreDataManager: HabitDataSource {
    
    private let context: NSManagedObjectContext
        
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func createHabit(habit: Habit) {
        let _ = HabitMapper.toEntety(habit: habit, context: context)
        try? context.save()
    }
    
    func fetchHabits(date: Date) -> [Habit] {
        let request = HabitEntities.fetchRequest()
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        request.predicate = NSPredicate(
            format: "createdAt >= %@ AND createdAt < %@",
            startOfDay as NSDate,
            endOfDay as NSDate
        )
        
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        
        do {
            let habits = try context.fetch(request)
            let habitDomain = habits.map {
                HabitMapper.toDomain(entity: $0)
            }
            return habitDomain
        } catch {
            print("Error fetching habits: \(error)")
            return []
        }
    }
    
    func updateHabit(habitId: String, habit: Habit) {
        let request = HabitEntities.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", habitId)
        
        if let habits = try? context.fetch(request), !habits.isEmpty, let resultHabit = habits.first {
            resultHabit.title = habit.title
            resultHabit.emoji = habit.emoji
            resultHabit.habitsID = habit.habitsID
            resultHabit.createdAt = habit.createdAt
            resultHabit.id = habit.id
            resultHabit.isCompletedToday = habit.isCompletedToday
            try? context.save()
        }
    }
    
    func deleHabit(id: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HabitEntities")
        request.predicate = NSPredicate(format: "habitsID == %@", id)
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(deleteRequest)
            context.reset()
            print("All habits with title '\(id)' deleted successfully using batch delete")
        } catch {
            print("Error deleting habits with title '\(id)': \(error)")
        }
    }
}
