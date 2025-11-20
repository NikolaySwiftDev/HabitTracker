import Foundation
extension Date {
    // Проверка на тот же день
    func isSameDay(as date: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: date)
    }
    
    // Начало дня
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    // День месяца
    var dayNumber: Int {
        Calendar.current.component(.day, from: self)
    }
    
    // Буква дня недели
    var dayOfWeekInitial: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return String(formatter.string(from: self).prefix(1))
    }
    
    // Строка месяца и года
    var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: self)
    }
    
    // Добавление дней
    func adding(days: Int) -> Date? {
        Calendar.current.date(byAdding: .day, value: days, to: self)
    }
}
