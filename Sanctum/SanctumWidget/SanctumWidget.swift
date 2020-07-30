import Intents
import SwiftUI
import WidgetKit

struct Provider: IntentTimelineProvider {
    public func snapshot(for configuration: ConfigurationIntent, with context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    public func timeline(for configuration: ConfigurationIntent, with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    public let date: Date
    public let configuration: ConfigurationIntent
}

struct PlaceholderView : View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(0 ..< 3) { index in
                HStack {
                    VStack(alignment: .leading) {
                        Text("Name in: Channel time")
                            .font(.footnote)
                        Text("Some message")
                            .font(.body)
                    }
                        .lineLimit(1)
                        .redacted(reason: .placeholder)

                    Spacer()
                }
            }

            Spacer()
        }
            .padding()
    }
}

// url
// this is post in channel
// https://chat.synology.com/channelID/postID
// this is post2 in thread of post1 in channel
// https://chat.synology.com/channelID/postID1/postID2

struct SanctumWidgetView: View {
    let entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(0 ..< 3) { index in
                HStack {
                    VStack(alignment: .leading) {
                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                            Text("Name")
                                .fontWeight(.bold)
                            Text("in:")
                                .foregroundColor(.secondary)
                            Text("Channel")
                                .fontWeight(.bold)
                            Text("time")
                                .foregroundColor(.secondary)
                                .layoutPriority(1)
                        }
                        .font(.footnote)
                        Text("Some message")
                            .font(.body)
                    }
                        .lineLimit(1)

                    Spacer()
                }
            }

            Spacer()
        }
            .padding()
            .widgetURL(URL(string: "https://chat.synology.com/123/234"))
    }
}

@main
struct SanctumWidget: Widget {
    private let kind: String = "SanctumWidget"

    public var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider(), placeholder: PlaceholderView()) { entry in
            SanctumWidgetView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemLarge, .systemMedium])
    }
}

struct SanctumWidget_Previews: PreviewProvider {
    static var previews: some View {
        SanctumWidgetView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
