import SwiftUI
import WidgetKit

struct BlankEntry: TimelineEntry {
    let date: Date
}

struct BlankTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> BlankEntry {
        BlankEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (BlankEntry) -> ()) {
        completion(BlankEntry(date: Date()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<BlankEntry>) -> ()) {
        let entries = [BlankEntry(date: Date())]
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

struct BlankWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Blank", provider: BlankTimelineProvider()) { _ in
            Spacer()
                .widgetURL(URL(string: "widget:///blank")!)
        }
    }
}
