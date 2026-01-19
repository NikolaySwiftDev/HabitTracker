
import ActivityKit
import WidgetKit
import SwiftUI


struct HabitActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var streak: Int
        var isCompletedToday: Bool
    }

    var habitName: String
}


struct HabitWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: HabitActivityAttributes.self) { context in
            // Lock Screen / Banner UI
            ZStack {
                LinearGradient(
                    colors: context.state.isCompletedToday
                        ? [Color.green, Color.green.opacity(0.7)]
                        : [Color.red, Color.red.opacity(0.7)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 8) {
                    Text(context.attributes.habitName)
                        .font(.caption)
                        .foregroundColor(.white)

                    Text("🔥 Streak: \(context.state.streak)")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)

                    Text(context.state.isCompletedToday ? "Completed ✅" : "Not completed ❌")
                        .font(.caption2)
                        .foregroundColor(.white)
                }
                .padding()
            }

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text("🔥")
                        .font(.headline)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("\(context.state.streak)")
                        .font(.headline)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text(context.state.isCompletedToday ? "Completed ✅" : "Not done ❌")
                        .font(.caption)
                }
            } compactLeading: {
                Text("🔥")
            } compactTrailing: {
                Text("\(context.state.streak)")
            } minimal: {
                Text(context.state.isCompletedToday ? "✅" : "❌")
            }
            .widgetURL(URL(string: "habitapp://habit"))
            .keylineTint(Color.green)
        }
    }
}

#Preview("Lock Screen", as: .content, using: HabitActivityAttributes(habitName: "Workout")) {
    HabitWidgetLiveActivity()
} contentStates: {
    HabitActivityAttributes.ContentState(streak: 5, isCompletedToday: true)
    HabitActivityAttributes.ContentState(streak: 3, isCompletedToday: false)
}
