

import Foundation
import Combine


final class HabitListViewModel: ObservableObject {
    
    @Published var habits: [Habit] = []
    
    private let deleteHabitUseCase: DeleteHabitUseCase
    private let fetchHabitsUseCase: FetchHabitsUseCase
    private let updateHabitUseCase: UpdateHabitUseCase
    private let createHabitUseCase: CreateHabitUseCase

    
    init(deleteHabitUseCase: DeleteHabitUseCase, fetchHabitsUseCase: FetchHabitsUseCase, updateHabitUseCase: UpdateHabitUseCase, createHabitUseCase: CreateHabitUseCase) {
        self.deleteHabitUseCase = deleteHabitUseCase
        self.fetchHabitsUseCase = fetchHabitsUseCase
        self.updateHabitUseCase = updateHabitUseCase
        self.createHabitUseCase = createHabitUseCase        
    }
    
    func fetchHabits(date: Date) {
        habits = fetchHabitsUseCase.execute(date: date)
    }
    
    func deleteHabit(habitId: String) {
        deleteHabitUseCase.execute(habitId: habitId)
    }
    
    func updateHabit(habitId: String, habit: Habit) {
        updateHabitUseCase.execute(habitId: habitId, habit: habit)
    }
    
    func createHabit(habit: Habit) {
        createHabitUseCase.execute(habit: habit)
    }
}

let mockHabit = Habit(id: UUID.init(),
                      title: "ЗОЖ",
                      body: "Соблюдать режим",
                      streak: 0,
                      isCompletedToday: false,
                      createdAt: .now)
