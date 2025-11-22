
import Foundation
import Combine

final class CreateHabitViewModel: ObservableObject {
    
    private let createHabitUseCase: CreateHabitUseCase
    
    init(createHabitUseCase: CreateHabitUseCase) {
        self.createHabitUseCase = createHabitUseCase
    }
    
    func createHaibt(habit: Habit) {
        createHabitUseCase.execute(habit: habit)
    }
    
}
