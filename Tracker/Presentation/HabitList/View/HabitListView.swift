
import SwiftUI

struct HabitListView: View {
    @StateObject var vm: HabitListViewModel
    @State private var selectedDate = Date()
    
    var body: some View {
        VStack(spacing: 20) {
            
            NavigationBar {
                
                var model = mockHabit
                model.createdAt = selectedDate
                
                vm.createHabit(habit: model)
                vm.fetchHabits(date: selectedDate)
            }
            
            CalendarView(selectedDate: $selectedDate)
            
            List {
                ForEach(vm.habits.indices, id: \.self) { index in
                    HabitListCell(title: vm.habits[index].title)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                        .listRowSeparator(.hidden)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                vm.deleteHabit(habitId: vm.habits[index].id.uuidString)
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
            .listStyle(PlainListStyle())
            .background(Color.clear)
            
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
