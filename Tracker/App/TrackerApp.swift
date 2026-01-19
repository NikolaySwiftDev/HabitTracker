

import SwiftUI
import WidgetKit

@main
struct TrackerApp: App {
    @Environment(\.scenePhase) private var scenePhase
    var body: some Scene {
        WindowGroup {
            HabitListView(vm: Assembly.createHabitListViewModel())
        }
        .onChange(of: scenePhase) { phase in
            if phase == .background {
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
    }
}
