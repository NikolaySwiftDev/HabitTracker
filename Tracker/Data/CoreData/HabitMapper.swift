
import Foundation
import CoreData

struct HabitMapper {
    static func toEntety(habit: Habit, context: NSManagedObjectContext) -> HabitEntities {
        let entity = HabitEntities(context: context)
        entity.id = habit.id
        entity.title = habit.title
        entity.body = habit.body
        entity.isCompletedToday = habit.isCompletedToday
        entity.createdAt = habit.createdAt
        entity.streak = habit.streak
        entity.colorHex = habit.colorHex
        return entity
    }
    
    static func toDomain(entity: HabitEntities) -> Habit {
        let habit = Habit(id: entity.id ?? UUID(),
                          title: entity.title ?? "",
                          body: entity.body ?? "",
                          colorHex: entity.colorHex ?? "",
                          streak: entity.streak,
                          isCompletedToday: entity.isCompletedToday,
                          createdAt: entity.createdAt ?? .now)
        return habit
    }
}
