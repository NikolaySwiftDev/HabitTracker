

import SwiftUI

struct HabitListCell: View {

    let habit: Habit
    let action: () -> Void

    @State private var pressed = false

    var body: some View {
        ZStack {
            HStack(spacing: 20) {
                Text(habit.emoji)
                    .font(.fontSystem(size: 28, weight: .semibold))

                Text(habit.title)
                    .font(.fontSystem(size: 28, weight: .semibold))

                Spacer()

                Circle()
                    .fill(habit.isCompletedToday ? .black: .clear)
                    .overlay(Circle().stroke(Color.black, lineWidth: 1))
                    .frame(width: 25, height: 25)
            }
            .padding(12)
            .background(.gray.opacity(0.2))
            .cornerRadius(20)
            .scaleEffect(pressed ? 0.95 : 1.0)
            .animation(
                .spring(
                    response: 0.28,
                    dampingFraction: 0.55,
                    blendDuration: 0
                ),
                value: pressed
            )
        }
        .contentShape(Rectangle())
        .onTapGesture {
            runSpring()
            action()
        }
    }

    private func runSpring() {
        pressed = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            pressed = false
        }

    }
}


#Preview {
    HabitListCell(habit: Habit.init(id: UUID.init(), habitsID: UUID.init(), title: "Sport", emoji: "🏃‍♀️", streak: 1, isCompletedToday: false, createdAt: .now)) {
        //
    }
    .frame(height: 60)
}
