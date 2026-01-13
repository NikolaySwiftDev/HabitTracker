
import SwiftUI

struct HabitListView: View {
    @StateObject var vm: HabitListViewModel
    @State private var selectedDate = Date()
    @State private var showingCreateHabit = false
    @State private var updateDDailyprogress = false
    
    var body: some View {
        VStack(spacing: 20) {
            
            NavigationBar {
                showingCreateHabit.toggle()
            }
            
            CalendarView(selectedDate: $selectedDate, completedDates: vm.datesComplete)
            
            List {
                ForEach(vm.habits) { habit in
                    HabitListCell(habit: habit, action: {
                        vm.updateHabit(habitId: habit.id.uuidString, habit: habit)
                        vm.fetchHabits(date: selectedDate)
                        if vm.checkIsAllHabitsComplete() {
                            updateDDailyprogress = true
                            vm.updateDailyprogress(isComplete: true, date: selectedDate)
                        } else {
                            if updateDDailyprogress {
                                vm.updateDailyprogress(isComplete: false, date: selectedDate)
                                updateDDailyprogress = false
                            }
                        }
                        
                    })
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                    .listRowSeparator(.hidden)
                    
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            let id = habit.habitsID.uuidString
                            vm.deleteHabit(id: id)
                            vm.removeNotification(identifier: id)
                            vm.fetchHabits(date: selectedDate)
                            if vm.habits.isEmpty {
                                vm.clearDailyprogress()
                            }
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
            
            if vm.checkIsAllHabitsComplete() {
                Text(vm.habits.isEmpty ? "No habits" : "Done all habits")
                    .foregroundStyle(.black)
                    .font(.fontSystem(size: 20, weight: .semibold))
                
                Text("Streak \(vm.streak)")
                    .foregroundStyle(.black)
                    .font(.fontSystem(size: 20, weight: .semibold))
            } else {
                Text("Do \(vm.checkCountsIsAllHabitsComplete()) habits")
                    .foregroundStyle(.black)
                    .font(.fontSystem(size: 20, weight: .semibold))
                
                Text("Streak \(vm.streak)")
                    .foregroundStyle(.black)
                    .font(.fontSystem(size: 20, weight: .semibold))
            }
            
        }
        .padding()
        .onAppear {
            vm.fetchHabits(date: selectedDate)
            vm.fetchDailyProgress()
            Task {
                await vm.requestNotificationPersmission()
            }
        }
        .onChange(of: selectedDate) { newDate in
            updateDDailyprogress = !vm.checkIsAllHabitsComplete()
            vm.fetchHabits(date: newDate)
            vm.fetchDailyProgress()
        }
        .onChange(of: vm.habits.isEmpty) { isEmpty in
          
        }
        .sheet(isPresented: $showingCreateHabit) {
            CreateHabitView(vm: Assembly.createCreateHabitViewModel(), action: {
                showingCreateHabit = false
                vm.fetchHabits(date: selectedDate)
                vm.fetchDailyProgress()
            })
        }
    }
}

#Preview {
    HabitListView(vm: Assembly.createHabitListViewModel())
}
