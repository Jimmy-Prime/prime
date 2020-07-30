import Foundation

struct CWBRequest: Request {
    let host = URL(string: "https://opendata.cwb.gov.tw/api")!
    let path = "/v1/rest/datastore/F-D0047-069"
    let queryItems: [String : String] = [
        "Authorization": "CWB-21A757FC-AC12-4E9D-9761-FCA25390676A",
        "elementName": "T",
        "locationName": "板橋區"
    ]
}

extension CWBRequest: DataRequest {
    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }

    struct Response: Codable {
        let records: Records

        struct Records: Codable {
            let locations: [City]
        }

        struct City: Codable {
            let location: [District]
        }

        struct District: Codable {
            let weatherElement: [WeatherElement]
        }

        struct WeatherElement: Codable {
            let description: String
            let time: [Time]
        }

        struct Time: Codable {
            let dataTime: Date
            let elementValue: [ElementValue]
        }

        struct ElementValue: Codable {
            let value: String
        }
    }
}
