

import SwiftUI

struct CreateHabitView: View {
    
    @StateObject var vm: CreateHabitViewModel
    
    @State var text: String = ""
    @State var textEmoji: String = "🏃‍♀️"
    @State var date: Date = .now
    @State var counterDay: Int = 10
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
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(20)
        .padding(.top)

    }
    
    func createbuttonAction () {
        let habitsID = UUID()
        for dayOffset in 0..<counterDay {

            if let habitDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: date) {
                let habit = Habit(
                    id: UUID(),
                    habitsID: habitsID,
                    title: text,
                    streak: 0,
                    isCompletedToday: false,
                    createdAt: habitDate
                )
                vm.createHabit(habit: habit)

              
                action()
            }
        }
        Task {
            await createPersmision()
        }
    }
    
    func createPersmision() async {
        guard text != "", toggle else {return}
        let hour = Calendar.current.component(.hour, from: notificationTime)
        let minute = Calendar.current.component(.minute, from: notificationTime)
        Task {
          try? await vm.createDailyNotification(identifier: text, title: text, body: "Do habit - \(text)", hour: hour, minute: minute)
        }
    }
}

#Preview {
    CreateHabitView(vm: Assembly.createCreateHabitViewModel(), action: {})
}


struct EmojiTextField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String = ""

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.text = text
        textField.delegate = context.coordinator
        textField.keyboardType = .emoji
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator($text)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String

        init(_ text: Binding<String>) {
            self._text = text
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
    }
}
