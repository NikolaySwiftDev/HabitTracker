import Foundation

struct Habit: Identifiable, Equatable {
    let id: UUID
    var title: String
    var body: String
    var colorHex: String?
    var streak: Int16
    var isCompletedToday: Bool
    var createdAt: Date
}
