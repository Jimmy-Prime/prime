import SwiftUI
import WidgetKit

struct ClockEntry: TimelineEntry {
    let date: Date
}

struct ClockTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> ClockEntry {
        ClockEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (ClockEntry) -> Void) {
        completion(ClockEntry(date: Date()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ClockEntry>) -> Void) {
        var entries: [ClockEntry] = []

        var components = Calendar.current.dateComponents(in: Calendar.current.timeZone, from: Date())
        components.second = 0
        components.nanosecond = 0
        for minute in components.minute! ... 60 {
            components.minute = minute
            let entry = ClockEntry(date: components.date!)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct ClockWidgetEntryView : View {
    var entry: ClockTimelineProvider.Entry

    var body: some View {
        ClockView(accuracy: .twoHands, date: entry.date)
            .widgetURL(URL(string: "widget:///clock")!)
    }
}

struct ClockWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Clock", provider: ClockTimelineProvider()) { entry in
            ClockWidgetEntryView(entry: entry)
        }
            .configurationDisplayName("Clock")
            .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct ClockWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ClockWidgetEntryView(entry: ClockEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            ClockWidgetEntryView(entry: ClockEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            ClockWidgetEntryView(entry: ClockEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
