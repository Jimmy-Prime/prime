import SwiftUI
import WidgetKit

struct YearlyReportEntry: TimelineEntry {
    let date: Date
    let intent: YearlyReportIntent
}

struct YearlyReportTimelineProvider: IntentTimelineProvider {
    typealias Entry = YearlyReportEntry

    typealias Intent = YearlyReportIntent

    func placeholder(in context: Context) -> Entry {
        Entry(date: Date(), intent: .init())
    }

    func getSnapshot(for configuration: Intent, in context: Context, completion: @escaping (Entry) -> Void) {
        completion(Entry(date: Date(), intent: configuration))
    }

    func getTimeline(for configuration: Intent, in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entry = Entry(date: Date(), intent: configuration)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct YearlyReport: Widget {
    let kind: String = "YearlyReport"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: YearlyReportIntent.self, provider: YearlyReportTimelineProvider()) { entry in
            YearlyReportView(entry: entry)
        }
            .configurationDisplayName("年度統計")
            .description("年度統計")
            .supportedFamilies([.systemMedium, .systemLarge])
    }
}

struct YearlyReportView: View {
    @Environment(\.widgetFamily) private var family

    var entry: YearlyReportTimelineProvider.Entry

    var body: some View {
        VStack {
            HStack {
                Text("2020")
                    .font(.system(size: 24, weight: .black, design: .rounded))

                Spacer()

                Text("\(sign)\(8888888)")
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundColor(entry.intent.style == .income ? .red : .green)
            }

            Spacer()

            HStack(alignment: entry.intent.style == .income ? .bottom : .top, spacing: 4) {
                ForEach(0..<12) { _ in
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundColor(entry.intent.style == .income ? .red : .green)
                        .frame(height: CGFloat.random(in: 8...barHeight))
                }
            }
                .frame(height: barHeight)
        }
            .padding()
            .background(entry.intent.style == .income ? GradientBackground(colors: .widgetRedFill) : GradientBackground(colors: .widgetGreenFill))
    }

    private var sign: String {
        entry.intent.style == .income ? "+" : "-"
    }

    private var barHeight: CGFloat {
        family == .systemMedium ? 78 : 240
    }
}

struct YearlyReportView_Previews: PreviewProvider {
    static var previews: some View {
        YearlyReportView(entry: .init(date: Date(), intent: .init()))
    }
}
