import WidgetKit

struct EmptyEntry: TimelineEntry {
    let date: Date

    static let instance: EmptyEntry = .init(date: Date(timeIntervalSince1970: 0))
}

struct SingleEntryProvider: TimelineProvider {
    typealias Entry = EmptyEntry

    func placeholder(in context: Context) -> Entry {
        .instance
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        completion(.instance)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entry = Entry.instance
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}
