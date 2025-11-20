
import Foundation

extension Calendar {
    static var currentCalendar: Calendar {
        var calendar = Calendar.current
        calendar.locale = Locale.current
        return calendar
    }
    
    // Генерация диапазона дат
    func generateDateRange(from startDate: Date, daysBefore: Int, daysAfter: Int) -> [Date] {
        var dates: [Date] = []
        
        // Дни до
        for day in (1...daysBefore).reversed() {
            if let date = self.date(byAdding: .day, value: -day, to: startDate) {
                dates.append(date)
            }
        }
        
        // Текущий день
        dates.append(startDate)
        
        // Дни после
        for day in 1...daysAfter {
            if let date = self.date(byAdding: .day, value: day, to: startDate) {
                dates.append(date)
            }
        }
        
        return dates
    }
}
