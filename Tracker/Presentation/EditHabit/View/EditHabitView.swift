import SwiftUI

struct EditHabitView: View {
    
    @StateObject var vm: EditHabitViewModel
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.dismiss) var dismiss
    
    @State private var text: String
    @State private var textEmoji: String
    @State private var toggle: Bool
    @State private var notificationTime: Date
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    let onSave: () -> Void
    
    init(vm: EditHabitViewModel, onSave: @escaping () -> Void) {
        _vm = StateObject(wrappedValue: vm)
        _text = State(initialValue: vm.habit.title)
        _textEmoji = State(initialValue: vm.habit.emoji)
        
        // Устанавливаем значения по умолчанию для уведомлений
        _toggle = State(initialValue: false)
        _notificationTime = State(initialValue: Date())
        
        self.onSave = onSave
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Edit Habit")
                    .font(.fontSystem(size: 28, weight: .bold))
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.gray.opacity(0.5))
                }
            }
            
            Text("Habit name")
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
            
            // Информация о привычке
            ZStack {
                Color.gray.opacity(0.2)
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "calendar")
                            .frame(width: 25, height: 25)
                        Text("Start date: \(vm.habit.createdAt, style: .date)")
                            .font(.fontSystem(size: 18, weight: .regular))
                        Spacer()
                    }
                    
                    HStack {
                        Image(systemName: "checkmark.circle")
                            .frame(width: 25, height: 25)
                        Text("Day: \(vm.habit.dayCount + 1)")
                            .font(.fontSystem(size: 18, weight: .regular))
                    }
                    
                    HStack {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .frame(width: 25, height: 25)
                        Text("Status: \(vm.habit.isCompletedToday ? "Completed" : "Not completed")")
                            .font(.fontSystem(size: 18, weight: .regular))
                    }
                }
                .padding(20)
            }
            .frame(height: 150)
            .cornerRadius(25)
            
            // Уведомления
            ZStack {
                Color.gray.opacity(0.2)
                HStack {
                    Image(systemName: "bell")
                        .resizable()
                        .frame(width: 25, height: 25)
                    
                    Text("Notification")
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
                saveButtonAction()
            } label: {
                ZStack {
                    Color.gray.opacity(0.2)
                        .cornerRadius(20)
                        .frame(height: 70)
                    
                    Text("Save Changes")
                        .font(.fontSystem(size: 24, weight: .bold))
                        .foregroundStyle(.black)
                }
            }
            .disabled(text.isEmpty)
            
            Spacer()
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
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
    }
    
    private func saveButtonAction() {
        Task {
            do {
                try await vm.editHabit(
                    newTitle: text,
                    newEmoji: textEmoji,
                    newNotificationTime: toggle ? notificationTime : nil,
                    hasNotification: toggle
                )
                
                onSave()
                dismiss()
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }
}

#Preview {
    let habit = Habit(
        id: UUID(),
        habitsID: UUID(),
        title: "Running",
        emoji: "🏃‍♂️",
        isCompletedToday: false,
        createdAt: Date(),
        dayCount: 5
    )
    
    EditHabitView(
        vm: Assembly.createEditHabitViewModel(for: habit),
        onSave: {}
    )
}
