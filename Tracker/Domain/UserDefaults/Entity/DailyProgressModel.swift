import Foundation

struct DailyProgress: Identifiable, Equatable, Codable {
    let id = UUID.init()
    let date: Date
    let streak: Int16
    let isComplete: Bool
}
