

import Foundation
import Combine


final class HabitListViewModel: ObservableObject {
    
    @Published var habits: [Habit] = []
    
    private let deleteHabitUseCase: DeleteHabitUseCase
    private let fetchHabitsUseCase: FetchHabitsUseCase
    private let updateHabitUseCase: UpdateHabitUseCase
    
    init(deleteHabitUseCase: DeleteHabitUseCase, fetchHabitsUseCase: FetchHabitsUseCase, updateHabitUseCase: UpdateHabitUseCase) {
        self.deleteHabitUseCase = deleteHabitUseCase
        self.fetchHabitsUseCase = fetchHabitsUseCase
        self.updateHabitUseCase = updateHabitUseCase
    }
    
    func fetchHabits(date: Date) {
        habits = fetchHabitsUseCase.execute(date: date)
    }
    
    func deleteHabit(title: String) {
        deleteHabitUseCase.execute(title: title)
    }
    
    func updateHabit(habitId: String, habit: Habit) {
        updateHabitUseCase.execute(habitId: habitId, habit: habit)
    }
}

let mockHabit = Habit(id: UUID.init(),
                      title: "ЗОЖ",
                      body: "Соблюдать режим",
                      streak: 0,
                      isCompletedToday: false,
                      createdAt: .now)
