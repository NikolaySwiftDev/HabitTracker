
public import Foundation
public import CoreData

public typealias HabitEntitiesCoreDataClassSet = NSSet

@objc(HabitEntities)
public class HabitEntities: NSManagedObject {

}

public typealias HabitEntitiesCoreDataPropertiesSet = NSSet
extension HabitEntities {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HabitEntities> {
        return NSFetchRequest<HabitEntities>(entityName: "HabitEntities")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var habitsID: UUID?
    @NSManaged public var title: String?
    @NSManaged public var emoji: String?
    @NSManaged public var streak: Int16
    @NSManaged public var isCompletedToday: Bool
    @NSManaged public var createdAt: Date?

}

extension HabitEntities : Identifiable {

}
