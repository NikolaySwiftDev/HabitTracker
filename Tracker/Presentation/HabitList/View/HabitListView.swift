
import SwiftUI

struct HabitListView: View {
    @StateObject var vm: HabitListViewModel
    @State private var selectedDate = Date()
    @State private var showingCreateHabit = false
    
    
    var body: some View {
        VStack(spacing: 20) {
            
            NavigationBar {
                showingCreateHabit.toggle()
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

                                vm.deleteHabit(title: habit.habitsID.uuidString)
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
        .sheet(isPresented: $showingCreateHabit) {
            CreateHabitView(vm: Assembly.createCreateHabitViewModel(), action: {
                showingCreateHabit = false
                vm.fetchHabits(date: selectedDate)
                
            })
        }
    }
}

#Preview {
    HabitListView(vm: Assembly.createHabitListViewModel())
}
