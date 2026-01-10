
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
        return entity
    }
    
    static func toDomain(entity: HabitEntities) -> Habit {
        let habit = Habit(id: entity.id ?? UUID(),
                          habitsID: entity.habitsID ?? UUID(),
                          title: entity.title ?? "",
                          emoji: entity.emoji ?? "",
                          isCompletedToday: entity.isCompletedToday,
                          createdAt: entity.createdAt ?? .now)
        return habit
    }
    
//    static func toDomainWdidget(entity: HabitEntities) -> WidgetHabitSnapshot {
//        let habit = WidgetHabitSnapshot(id: entity.id?.uuidString ?? "",
//                                        title: entity.title ?? "",
//                                        emoji: entity.emoji ?? "",
//                                        isCompletedToday: entity.isCompletedToday,
//                                        streak: Int(entity.streak))
//        return habit
//    }
}
