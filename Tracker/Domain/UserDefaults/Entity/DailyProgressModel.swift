import Foundation

struct DailyProgress: Identifiable, Equatable, Codable {
    var id = UUID.init()
    var lastCompleteDate: Date?
    var streak: Int
    var isComplete: Bool
}
