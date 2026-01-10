
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
                        vm.updateHabit(habitId: habit.id.uuidString, habit: habit)
                        vm.fetchHabits(date: selectedDate)
                    })
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                        .listRowSeparator(.hidden)
                     
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                let id = habit.habitsID.uuidString
                                vm.deleteHabit(id: id)
                                vm.removeNotification(identifier: id)
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
            
            if vm.allHabitsComplete {
                Text("Done all habits")
                    .foregroundStyle(.green)
                    .font(.fontSystem(size: 20, weight: .semibold))
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            vm.fetchHabits(date: selectedDate)
            Task {
               await vm.requestNotificationPersmission()
            }
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
