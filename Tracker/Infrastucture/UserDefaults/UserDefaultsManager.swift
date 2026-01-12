
import Foundation


final class UserDefaultsManager: DailyProgressDataSource {
      
    private let userDefaults = UserDefaults.standard
    private let key = "DailyProgress"
    
    func updateDailyProgress(dailyProgress: DailyProgress) {
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(dailyProgress)
            userDefaults.set(encodedData, forKey: key)
        } catch {
            print("Error saving DailyProgress: \(error)")
        }
    }
    
    func getDailyProgress() -> DailyProgress? {
        guard let savedData = userDefaults.data(forKey: key) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let dailyProgress = try decoder.decode(DailyProgress.self, from: savedData)
            return dailyProgress
        } catch {
            print("Error loading DailyProgress: \(error)")
            return nil
        }
    }
}
