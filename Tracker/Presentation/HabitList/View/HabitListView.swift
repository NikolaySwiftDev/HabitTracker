
import SwiftUI

struct HabitListView: View {
    @StateObject var vm: HabitListViewModel
    @State private var selectedDate = Date()
    
    var body: some View {
        VStack(spacing: 20) {
            
            NavigationBar {
                
                var model = mockHabit
                model.createdAt = selectedDate
                model.id = UUID.init()
                
                vm.createHabit(habit: model)
                vm.fetchHabits(date: selectedDate)
            }
            
            CalendarView(selectedDate: $selectedDate)
            
            List {
                ForEach(vm.habits) { habit in
                    HabitListCell(habit: habit, action: {
                        var newHabit = habit
                        newHabit.isCompletedToday.toggle()
                        vm.updateHabit(habitId: habit.id.uuidString, habit: newHabit)
                        vm.fetchHabits(date: selectedDate)
                    })
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                        .listRowSeparator(.hidden)
                     
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                vm.deleteHabit(habitId: habit.id.uuidString)
                            } label: {
                                VStack {
                                    Image(systemName: "trash")
                                    Text("Delete")
                                        .font(.caption)
                                }
                            }
                        }
                }
            }
            .listStyle(.plain)
            
            Spacer()
        }
        .padding()
        .onAppear {
            vm.fetchHabits(date: selectedDate)
        }
        .onChange(of: selectedDate) { newDate in
            vm.fetchHabits(date: newDate)
        }
    }
}

#Preview {
    HabitListView(vm: Assembly.createHabitListViewModel())
}
