import Foundation

struct CurrentCountryResponse: Decodable {
    let status: String
    let country: String
    let countryCode: String
    let region: String
    let regionName: String
    let city: String
    let zip: String
    let lat: Double
    let lon: Double
    let timezone: String
    let isp: String
    let org: String
    let query: String
}

struct GetCurrentCountryRequest: APIRequest {
    typealias Response = CurrentCountryResponse
    
    var baseURL: String { "http://ip-api.com" }
    var path: String { "/json" }
    var method: HTTPMethod { .GET }
    var headers: [String: String]? { nil }
    var queryParams: [String: String]? { nil }
    var body: Data? { nil }
} 