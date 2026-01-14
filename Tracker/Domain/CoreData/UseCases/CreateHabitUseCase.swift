import Foundation

protocol CreateHabitUseCase: AnyObject {
    func execute(habitsID: UUID, title: String, emoji: String, startDate: Date, daysCount: Int)
}

final class CreateHabitImplement: CreateHabitUseCase {
    
    
    private let repository: CreateHabitRepository
    
    init(repository: CreateHabitRepository) {
        self.repository = repository
    }
    
    func execute(habitsID: UUID, title: String, emoji: String, startDate: Date, daysCount: Int) {
        guard daysCount > 0 else { return }
        var emojiNew = emoji
        if emoji == "" {
            emojiNew = "💡"
        }
        for dayOffset in 0..<daysCount {
            if let habitDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: startDate) {
                let habit = Habit(
                    id: UUID(),
                    habitsID: habitsID,
                    title: title,
                    emoji: emojiNew,
                    isCompletedToday: false,
                    createdAt: habitDate,
                )
                repository.createHabit(habit: habit)
            }
        }
    }
}
