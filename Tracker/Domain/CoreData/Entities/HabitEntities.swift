import Foundation

struct Habit: Identifiable, Equatable {
    let id: UUID
    let habitsID: UUID
    let title: String
    let emoji: String
    var isCompletedToday: Bool
    let createdAt: Date
}
