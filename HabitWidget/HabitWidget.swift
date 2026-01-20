

import WidgetKit
import SwiftUI


struct Provider: TimelineProvider {
    
    private let useCase: BuildWidgetSnapshotUseCase = {
        let dataSource = UserDefaultsManager()
        let repository = BuildWidgetRepositoryImplement(
            dataSource: dataSource
        )
        return BuildWidgetSnapshotImplementation(
            repository: repository
        )
    }()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: .now,
            snapshot: WidgetHabitSnapshot(
                isCompletedToday: false,
                streak: 0
            )
        )
    }
    
    func getSnapshot(
        in context: Context,
        completion: @escaping (SimpleEntry) -> Void
    ) {
        completion(
            SimpleEntry(
                date: .now,
                snapshot: useCase.getDailyProgress()
            )
        )
    }
    
    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<SimpleEntry>) -> Void
    ) {
        let entry = SimpleEntry(
            date: .now,
            snapshot: useCase.getDailyProgress()
        )
        
        let timeline = Timeline(
            entries: [entry],
            policy: .after(.now.addingTimeInterval(15 * 60))
        )
        
        completion(timeline)
    }
}




struct SimpleEntry: TimelineEntry {
    let date: Date
    let snapshot: WidgetHabitSnapshot?
}

import SwiftUI

struct HabitWidgetEntryView: View {
    
    let entry: SimpleEntry
    
    var body: some View {
        ZStack {
            VStack(spacing: 8) {
                if let snapshot = entry.snapshot {
                    HStack(alignment: .center, spacing: 0) {
                        Text("🔥")
                            .font(.system(size: 12, weight: .black, design: .serif))
                            .foregroundColor(.white)
                        Text(" Streak")
                            .font(.system(size: 18, weight: .black, design: .serif))
                            .foregroundColor(.white)
                    }
                    
                    
                    Text("\(snapshot.streak)")
                        .font(.system(size: 30, weight: .black, design: .serif))
                        .bold()
                        .foregroundColor(.white)
                    
                    HStack(alignment: .center, spacing: 0) {
                        Text("\(snapshot.isCompletedToday ? "Completed ✅" : "Not completed ❌")")
                            .font(.system(size: 12, weight: .semibold, design: .serif))
                            .foregroundColor(.white)
                    }
                    
                } else {
                    Text("No data")
                        .font(.system(size: 30, weight: .bold, design: .serif))
                        .foregroundColor(.white)
                }
            }
        }
    }
}


struct HabitWidget: Widget {
    
    let kind: String = "HabitWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: Provider()
        ) { entry in
            ZStack {
                
                if #available(iOS 17.0, *) {
                    HabitWidgetEntryView(entry: entry)
                        .containerBackground(LinearGradient(colors: entry.snapshot?.isCompletedToday == true
                                                            ? [Color.green, Color.green.opacity(0.5)]
                                                            : [Color.red, Color.red.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing), for: .widget)
                } else {
                    HabitWidgetEntryView(entry: entry)
                        .background(LinearGradient(colors: entry.snapshot?.isCompletedToday == true
                                                   ? [Color.green, Color.green.opacity(0.5)]
                                                   : [Color.red, Color.red.opacity(0.5)], startPoint: .bottom, endPoint: .center))
                }
            }
        }
        .configurationDisplayName("Habit Tracker")
        .description("Shows your daily habit streak")
        .supportedFamilies([.systemSmall])
    }
}

