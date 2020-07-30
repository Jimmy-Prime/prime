import Foundation

struct NewsAPITopHeadLinesRequest: Request {
    let host = URL(string: "https://newsapi.org")!
    let path = "/v2/top-headlines"
    let queryItems: [String : String]

    enum Category: String {
        case business
        case entertainment
        case general
        case health
        case science
        case sports
        case technology
    }

    // 2-letter ISO 3166-1 code
    init(country: String, category: Category) {
        queryItems = [
            "country": country,
            "category": category.rawValue,
            "pageSize": "100",
            "apiKey": "cdea85a393e24d1caf9cd431ba1c976b"
        ]
    }
}

extension NewsAPITopHeadLinesRequest: DataRequest {
    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }

    struct Response: Codable {
        let articles: [Article]

        struct Article: Codable {
            let source: Source
            let author: String?
            let title: String
            let description: String?
            let publishedAt: String
        }

        struct Source: Codable {
            let id: String?
            let name: String
        }
    }
}
