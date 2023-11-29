import Foundation

struct JsonModel: Codable {
    let iconUrl: String
    let id, url, value: String
    
    enum CodingKeys: String, CodingKey {
        case iconUrl = "icon_url"
        case id, url, value
    }
}
