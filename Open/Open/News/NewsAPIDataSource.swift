import Foundation

class NewsAPIDataSource: TableViewItemDataSource<News> {
    override func fetcher(completion: @escaping (Result<[News], Error>) -> Void) {
        URLSession.shared.send(NewsAPITopHeadLinesRequest(country: "tw", category: .technology)) { (result) in
            completion(result.map { response in
                response.articles.map(News.adapter)
            })
        }
    }
}
