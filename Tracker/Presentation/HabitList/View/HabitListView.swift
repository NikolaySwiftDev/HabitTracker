
import SwiftUI

struct HabitListView: View {
    @StateObject var vm: HabitListViewModel
    @State private var selectedDate = Date()
    @State private var showingCreateHabit = false
    @State private var showingEditHabit = false
    @State private var selectedHabitForEdit: Habit?
    @State private var showFutureDateAlert = false
    @State private var showConfetti = false

    
    var body: some View {
        VStack(spacing: 20) {
            
            NavigationBar {
                showingCreateHabit.toggle()
            }
            
            CalendarView(selectedDate: $selectedDate, completedDates: vm.datesComplete)
            
            List {
                ForEach(vm.habits) { habit in
                    HabitListCell(habit: habit, action: {
                        Task {
                            showFutureDateAlert = await vm.updateHabit(habitId: habit.id.uuidString, habit: habit, date: selectedDate)
                            await vm.removeNotificationFromDay(identifier: habit.habitsID.uuidString, day: habit.dayCount)
                            
                            let wasCompleted = habit.isCompletedToday
                            if !wasCompleted && !showFutureDateAlert {
                                triggerConfetti()
                            }
                        }
                    })
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                    .listRowSeparator(.hidden)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            let id = habit.habitsID.uuidString
                            vm.deleteHabit(id: id, date: selectedDate)
                        } label: {
                            VStack {
                                Image(systemName: HabitListInfo.deleteButtonImage)
                                Text(HabitListInfo.deleteButtonTitle)
                                    .font(.caption)
                            }
                        }
                        
                        Button {
                            selectedHabitForEdit = habit
                            showingEditHabit = true
                        } label: {
                            VStack {
                                Image(systemName: HabitListInfo.editButtonImage)
                                Text(HabitListInfo.editButtonTitle)
                                    .font(.caption)
                            }
                        }
                        .tint(.blue)
                    }
                }
            }
            .listStyle(.plain)
            
            Spacer()
            
            creacteCompletedBlock(isShow: vm.checkIsAllHabitsComplete(), emptyText: vm.habits.isEmpty)

        }
        .padding()
        .confetti(isActive: $showConfetti)
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
        .sheet(isPresented: $showingEditHabit) {
            if let habit = selectedHabitForEdit {
                EditHabitView(vm: Assembly.createEditHabitViewModel(for: habit), onSave: {
                    vm.fetchHabits(date: selectedDate)
                })
            }
        }
        .alert(HabitListInfo.titleAlert,
               isPresented: $showFutureDateAlert) {
            Button(HabitListInfo.buttonAlert, role: .cancel) {}
        } message: {
            Text(HabitListInfo.messageAlert)
        }
    }
    
    private func creacteCompletedBlock(isShow: Bool, emptyText: Bool) ->  some View {
        VStack {
            if isShow {
                Text(emptyText ? HabitListInfo.noHabits : HabitListInfo.doneHabits)
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
    
    private func triggerConfetti() {
        showConfetti = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            showConfetti = false
        }
    }
}

#Preview {
    HabitListView(vm: Assembly.createHabitListViewModel())
}

fileprivate struct HabitListInfo {
    static let noHabits = "No habits"
    static let doneHabits = "Done all habits"
    
    static let titleAlert = "You can't mark it in advance"
    static let messageAlert = "Habits can only be marked for today or for the past few days."
    static let buttonAlert = "Ok"
    
    static let deleteButtonImage = "trash"
    static let deleteButtonTitle = "Delete"
    
    static let editButtonImage = "pencil"
    static let editButtonTitle = "Edit"
}
