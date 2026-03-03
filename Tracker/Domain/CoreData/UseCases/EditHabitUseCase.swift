import Foundation

protocol EditHabitUseCase: AnyObject {
    func execute(habit: Habit, newTitle: String, newEmoji: String) async throws
}

final class EditHabitImplement: EditHabitUseCase {
    
    private let repository: UpdateHabitRepository
    
    init(repository: UpdateHabitRepository) {
        self.repository = repository
    }
    
    func execute(habit: Habit, newTitle: String, newEmoji: String) async throws {
        guard !newTitle.isEmpty else {
            throw EditHabitError.emptyTitle
        }
        
        let finalEmoji = newEmoji.isEmpty ? "💡" : newEmoji
        
        let updatedHabit = Habit(
            id: habit.id,
            habitsID: habit.habitsID,
            title: newTitle,
            emoji: finalEmoji,
            isCompletedToday: habit.isCompletedToday,
            createdAt: habit.createdAt,
            dayCount: habit.dayCount
        )
        
        repository.updateHabit(habitId: habit.id.uuidString, habit: updatedHabit)
    }
}

enum EditHabitError: Error {
    case emptyTitle
}
