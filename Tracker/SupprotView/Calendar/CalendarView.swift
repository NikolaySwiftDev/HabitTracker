import SwiftUI

struct CalendarView: View {
    @Binding var selectedDate: Date
    @State private var dates: [Date] = []
    
    let completedDates: Set<Date>
    private let calendar = Calendar.currentCalendar
    private let daysBefore = 7
    private let daysAfter = 10

    
    var body: some View {
        VStack(spacing: 0) {
            Text(selectedDate.monthYearString)
                .font(.headline)
                .padding(0)
            
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(dates.indices, id: \.self) { index in
                            let date = dates[index]
                            
                            DayView(
                                date: date,
                                isSelected: date.isSameDay(as: selectedDate),
                                isToday: date.isSameDay(as: Date()),
                                isCompleted: completedDates.contains {
                                    $0.isSameDay(as: date)
                                }
                            )
                            .id(index)
                            .onTapGesture {
                                selectedDate = date
                            }
                        }
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        scrollToToday(proxy: proxy)
                    }
                }
            }
        }
        .onAppear {
            generateDates()
        }
    }
    
    private func generateDates() {
        dates = calendar.generateDateRange(
            from: Date(),
            daysBefore: daysBefore,
            daysAfter: daysAfter
        )
    }
    
    // Прокрутка к сегодняшней дате
    private func scrollToToday(proxy: ScrollViewProxy) {
        if let todayIndex = dates.firstIndex(where: { $0.isSameDay(as: Date()) }) {
            proxy.scrollTo(todayIndex, anchor: .center)
        }
    }
}

struct DayView: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let isCompleted: Bool

    
    var body: some View {
        VStack(spacing: 4) {
            Text(date.dayOfWeekInitial)
                .font(.caption)
                .foregroundColor(isSelected ? .white : isCompleted ? .black : .gray)
            
            Text("\(date.dayNumber)")
                .font(.fontSystem(size: 16, weight: .medium))
                .foregroundColor(isSelected ? .white : isCompleted ? .black : .primary)
        }
        .frame(width: 40, height: 60)
        .background(
            Circle()
                .fill(backgroundColor)
                .frame(width: 45, height: 45)
        )
        .overlay(
            Circle()
                .stroke(borderColor, lineWidth: isToday ? 2 : 0)
                .frame(width: 45, height: 45)
        )
        .padding(.horizontal, 4)
    }
    
    private var backgroundColor: Color {
        isSelected ? .black : isCompleted ? .green.opacity(0.3) : .clear
    }
    
    private var borderColor: Color {
        (isToday && !isSelected) ? .black : .clear
    }
}

#Preview {
    CalendarView(selectedDate: .constant(Date()), completedDates: [])
}
