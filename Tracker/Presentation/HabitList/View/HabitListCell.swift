

import SwiftUI

struct HabitListCell: View {
    
    let habit: Habit
    let action: () -> Void
    
    @State private var glow = false
    @State private var pressed = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .stroke(glow ? habit.isCompletedToday ? Color.green.opacity(0.5) : Color.red.opacity(0.5) : Color.clear, lineWidth: 4)
                .blur(radius: 2)
                .opacity(glow ? 1 : 0)
                .animation(.easeOut(duration: 0.45), value: glow)
            
            // Основная ячейка
            HStack(spacing: 20) {
                Image(uiImage: .checkmark)
                    .resizable()
                    .frame(width: 20, height: 20)
                
                Text(habit.title)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Circle()
                    .fill(habit.isCompletedToday ? .green : .clear)
                    .overlay(
                        Circle().stroke(Color.black, lineWidth: 1)
                    )
                    .frame(width: 25, height: 25)
            }
            .padding(12)
            .background(.gray.opacity(0.2))
            .cornerRadius(20)
            .scaleEffect(pressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.6), value: pressed)
        }
        .onTapGesture {
            runGlow()
            action()
        }
    }
    
    private func runGlow() {
        // Лёгкий "тап-эффект"
        pressed = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            pressed = false
        }
        
        // Glow анимация
        glow = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
            glow = false
        }
    }
}
