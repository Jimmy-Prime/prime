import SwiftUI
import WidgetKit

struct NoteEntry: TimelineEntry {
    let date: Date
    let text: String
}

struct NoteTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> NoteEntry {
        NoteEntry(date: Date(), text: Defaults.note)
    }

    func getSnapshot(in context: Context, completion: @escaping (NoteEntry) -> Void) {
        completion(NoteEntry(date: Date(), text: Defaults.note))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<NoteEntry>) -> Void) {
        let entries = [NoteEntry(date: Date(), text: Defaults.note)]
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

struct NoteWidgetEntryView: View {
    var entry: NoteEntry

    var body: some View {
        HStack {
            Text(entry.text)
            Spacer()
        }
            .padding()
            .widgetURL(URL(string: "widget:///note")!)
    }
}

struct NoteWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Note", provider: NoteTimelineProvider()) { entry in
            NoteWidgetEntryView(entry: entry)
        }
            .configurationDisplayName("Note")
            .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct NoteWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NoteWidgetEntryView(entry: NoteEntry(date: Date(), text: "🤪🤪🤪"))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            NoteWidgetEntryView(entry: NoteEntry(date: Date(), text: "🤪🤪🤪"))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            NoteWidgetEntryView(entry: NoteEntry(date: Date(), text: "🤪🤪🤪"))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
