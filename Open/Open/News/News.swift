struct News: Hashable {
    let title: String
    let description: String

    static func adapter(_ item: Any) -> News {
        if let item = item as? NewsAPITopHeadLinesRequest.Response.Article {
            var description = item.source.name

            if let aDescription = item.description {
                description += " - \(aDescription)"
            }

            return News(title: item.title, description: description)
        } else {
            return News(title: "Unknown", description: "Unknown")
        }
    }
}
