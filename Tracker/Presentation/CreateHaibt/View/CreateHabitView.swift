

import SwiftUI

struct CreateHabitView: View {
    
    @StateObject var vm: CreateHabitViewModel
    
    @State var text: String = ""
    @State var textEmoji: String = "🏃‍♀️"
    @State var date: Date = .now
    @State var counterDay: Int = 10
    @State var toggle: Bool = false
    let action: ()->()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("New Habit")
                .font(.fontSystem(size: 28, weight: .bold))
            
            Text("Enter text")
                .font(.fontSystem(size: 22, weight: .regular))
            
            HStack {
                TextField("Sport", text: $text)
                    .font(.fontSystem(size: 24, weight: .bold))
                    .padding(15)
                    .padding(.leading, 10)
                    .foregroundStyle(.black)
                    .background(.gray.opacity(0.2))
                    .cornerRadius(25)
                Spacer()
                TextField("🏃‍♀️", text: $textEmoji)
                    .font(.fontSystem(size: 22, weight: .regular))
                    .multilineTextAlignment(.center)
                    .padding(15)
                    .foregroundStyle(.gray)
                    .background(.gray.opacity(0.2))
                    .cornerRadius(25)
                    .frame(width: 60)
            }
            
            ZStack {
                Color.gray.opacity(0.2)
                HStack {
                    Image(systemName: "calendar")
                        .resizable()
                        .frame(width: 25, height:  25)
                    
                    Text("Start from date")
                        .font(.fontSystem(size: 22, weight: .regular))
                        .minimumScaleFactor(0.6)
                    Spacer()
                    
                    DatePicker("", selection: $date, displayedComponents: .date)
                    
                }
                .padding(20)
                
            }
            .frame(height: 80)
            .cornerRadius(25)
            
            ZStack {
                Color.gray.opacity(0.2)
                HStack {
                    Image(systemName: "10.arrow.trianglehead.counterclockwise")
                        .resizable()
                        .frame(width: 25, height:  25)
                    
                    Text("Day counter")
                        .font(.fontSystem(size: 22, weight: .regular))
                        .minimumScaleFactor(0.6)
                    Spacer()
                    
                    HStack {
                        Button {
                            guard counterDay != 0 else {return}
                            counterDay -= 1
                        } label: {
                            Text("-")
                                .font(.fontSystem(size: 22, weight: .regular))
                                .foregroundStyle(.black)
                        }
                        
                        Text("\(counterDay)")
                            .font(.fontSystem(size: 22, weight: .regular))
                            .multilineTextAlignment(.center)
                            .padding(15)
                            .foregroundStyle(.black)
                            .background(.white.opacity(0.6))
                            .cornerRadius(25)
                            .frame(width: 65)
                        
                        Button {
                            guard counterDay != 21 else {return}
                            counterDay += 1
                        } label: {
                            Text("+")
                                .font(.fontSystem(size: 22, weight: .regular))
                                .foregroundStyle(.black)
                        }
                        
                    }
                }
                .padding(20)
                
            }
            .frame(height: 80)
            .cornerRadius(25)
            
            ZStack {
                Color.gray.opacity(0.2)
                HStack {
                    Image(systemName: "info.bubble")
                        .resizable()
                        .frame(width: 25, height:  25)
                    
                    Text("Notify daily")
                        .font(.fontSystem(size: 22, weight: .regular))
                        .minimumScaleFactor(0.6)
                    Spacer()
                    
                    Toggle("", isOn: $toggle)
                    
                    
                }
                .padding(20)
                
            }
            .frame(height: 80)
            .cornerRadius(25)
            
            Button {
                createbuttonAction()
            } label: {
                ZStack {
                    Color.gray.opacity(0.2)
                        .cornerRadius(20)
                        .frame(height: 70)
                    Text("Create")
                        .font(.fontSystem(size: 24, weight: .bold))
                        .foregroundStyle(.black)
                }
            }
            .disabled(text == "" )
        }
        .onAppear {
            Task {
                await vm.requestNotificationPersmission()
            }
        }
        .onChange(of: toggle) { old in
            Task {
                await createPersmision()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(20)
        .padding(.top)

    }
    
    func createbuttonAction () {
        for dayOffset in 0..<counterDay {
            if let habitDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: date) {
                let habit = Habit(
                    id: UUID(),
                    title: text,
                    body: "",
                    streak: 0,
                    isCompletedToday: false,
                    createdAt: habitDate
                )
                vm.createHaibt(habit: habit)
                action()
            }
        }
    }
    
    func createPersmision() async {
        guard text != "" else {return}
        Task {
          try? await vm.createDailyNotification(identifier: text, title: text, body: "Выполните \(text)", hour: 20, minute: 32)
        }
    }
}

#Preview {
    CreateHabitView(vm: Assembly.createCreateHabitViewModel(), action: {})
}
