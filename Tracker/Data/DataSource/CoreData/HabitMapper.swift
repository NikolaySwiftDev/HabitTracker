
import Foundation
import CoreData

struct HabitMapper {
    static func toEntety(habit: Habit, context: NSManagedObjectContext) -> HabitEntities {
        let entity = HabitEntities(context: context)
        entity.id = habit.id
        entity.habitsID = habit.habitsID
        entity.title = habit.title
        entity.emoji = habit.emoji
        entity.isCompletedToday = habit.isCompletedToday
        entity.createdAt = habit.createdAt
        entity.dayCount = habit.dayCount
        return entity
    }
    
    static func toDomain(entity: HabitEntities) -> Habit {
        let habit = Habit(id: entity.id ?? UUID(),
                          habitsID: entity.habitsID ?? UUID(),
                          title: entity.title ?? "",
                          emoji: entity.emoji ?? "",
                          isCompletedToday: entity.isCompletedToday,
                          createdAt: entity.createdAt ?? .now,
                          dayCount: entity.dayCount)
        return habit
    }
}
