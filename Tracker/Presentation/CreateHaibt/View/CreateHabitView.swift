

import SwiftUI

struct CreateHabitView: View {
    
    @StateObject var vm: CreateHabitViewModel
    @Environment(\.scenePhase) var scenePhase
    
    @State var text: String = "Sport"
    @State var textEmoji: String = "🏃‍♀️"
    @State var date: Date = .now
    @State var counterDay: Int = 10
//    @State var isNotificationIsAuthorized: Bool = false
    @State var toggle: Bool = false
    @State var notificationTime: Date = .now
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
                EmojiTextField(text: $textEmoji)
                    .background(.gray.opacity(0.2))
                    .cornerRadius(25)
                    .frame(width: 60)
            }
            .frame(height: 60)
            
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
                    
                    Text("Notify")
                        .font(.fontSystem(size: 22, weight: .regular))
                        .minimumScaleFactor(0.6)
                    Spacer()
                    
                    if toggle {
                        DatePicker(
                            "",
                            selection: $notificationTime,
                            displayedComponents: .hourAndMinute
                        )
                        .datePickerStyle(CompactDatePickerStyle())
                    }
                    
                    Toggle("", isOn: $toggle)
                        .disabled(!vm.isNotificationIsAuthorized)
                        .onTapGesture {
                            if !vm.isNotificationIsAuthorized {
                                UIApplication.shared.openAppSettings()
                            }
                        }
                    
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
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(20)
        .padding(.top)
        .onAppear {
            Task {
                await vm.getNotificationStatus()
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                Task {
                    await vm.getNotificationStatus()
                    if !vm.isNotificationIsAuthorized {
                        toggle = false
                    }
                }
            }
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
    
    func createbuttonAction () {
        let habitsID = UUID()
        vm.createHabitexecute(habitsID: habitsID, title: text, emoji: textEmoji, startDate: date, daysCount: counterDay)
        Task {
            try? await vm.createDailyNotification(id: habitsID, title: text, notificationTime: notificationTime, daysCount: counterDay, startDate: date)
        }
        action()
        
    }
}

#Preview {
    CreateHabitView(vm: Assembly.createCreateHabitViewModel(), action: {})
}


