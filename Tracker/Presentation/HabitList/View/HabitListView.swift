
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
            
            CalendarView(selectedDate: $selectedDate, completedDates: vm.datesComplete)
            
            List {
                ForEach(vm.habits) { habit in
                    HabitListCell(habit: habit, action: {
                        vm.updateHabit(habitId: habit.id.uuidString, habit: habit, date: selectedDate)
                        Task {
                            await vm.removeNotificationFromDay(identifier: habit.habitsID.uuidString, day: habit.dayCount)
                        }
                    })
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                    .listRowSeparator(.hidden)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            let id = habit.habitsID.uuidString
                            vm.deleteHabit(id: id, date: selectedDate)
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
            
            creacteCompletedBlock(isShow: vm.checkIsAllHabitsComplete(), emptyText: vm.habits.isEmpty)

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
            CreateHabitView(vm: Assembly.createCreateHabitViewModel(), date: selectedDate, action: {
                showingCreateHabit = false
                vm.fetchHabits(date: selectedDate)
            })
        }
    }
    
    private func creacteCompletedBlock(isShow: Bool, emptyText: Bool) ->  some View {
        VStack {
            if isShow {
                Text(emptyText ? "No habits" : "Done all habits")
                    .foregroundStyle(.black)
                    .font(.fontSystem(size: 20, weight: .semibold))
                
                Text("Streak \(vm.streak)")
                    .foregroundStyle(.black)
                    .font(.fontSystem(size: 16, weight: .semibold))
            } else {
                Text("Do \(vm.checkCountsIsAllHabitsComplete()) habits")
                    .foregroundStyle(.black)
                    .font(.fontSystem(size: 20, weight: .semibold))
                
                Text("Streak \(vm.streak)")
                    .foregroundStyle(.black)
                    .font(.fontSystem(size: 16, weight: .semibold))
            }
        }
    }
}

#Preview {
    HabitListView(vm: Assembly.createHabitListViewModel())
}
