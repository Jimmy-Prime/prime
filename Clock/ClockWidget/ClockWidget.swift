import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        var components = Calendar.current.dateComponents(in: Calendar.current.timeZone, from: Date())
        components.second = 0
        components.nanosecond = 0
        for minute in components.minute! ... 60 {
            components.minute = minute
            let entry = SimpleEntry(date: components.date!)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct ClockWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ClockView(accuracy: .twoHands, date: entry.date)
    }
}

@main
struct ClockWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Clock", provider: Provider()) { entry in
            ClockWidgetEntryView(entry: entry)
        }
            .configurationDisplayName("Clock")
            .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct ClockWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ClockWidgetEntryView(entry: SimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            ClockWidgetEntryView(entry: SimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            ClockWidgetEntryView(entry: SimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
