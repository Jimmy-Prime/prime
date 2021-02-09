import SwiftUI
import WidgetKit

struct GIFEntry: TimelineEntry {
    let date: Date
    let image: UIImage
}

struct GIFTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> GIFEntry {
        GIFEntry(date: Date(), image: UIImage())
    }

    func getSnapshot(in context: Context, completion: @escaping (GIFEntry) -> Void) {
        completion(GIFEntry(date: Date(), image: UIImage()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<GIFEntry>) -> Void) {
        let images = UIImage.gif(name: "partyblob")!.images!
        let count = images.count * Int((Float(60) / Float(images.count)).rounded(.up))

        let now = Date()
        let entries: [GIFEntry] = (0..<count).map { index in
            let date = Calendar.current.date(byAdding: .second, value: index, to: now)!
            return GIFEntry(date: date, image: images[index % images.count])
        }
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct GIFWidgetEntryView: View {
    var entry: GIFTimelineProvider.Entry

    var body: some View {
        Image(uiImage: entry.image)
            .widgetURL(URL(string: "widget:///gif")!)
    }
}

struct GIFWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "gif", provider: GIFTimelineProvider()) { entry in
            GIFWidgetEntryView(entry: entry)
        }
            .configurationDisplayName("Party Blob")
            .supportedFamilies([.systemSmall, .systemLarge])
    }
}
