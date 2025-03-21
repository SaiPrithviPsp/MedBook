import Foundation

struct CountryResponse: Decodable {
    let status: String
    let statusCode: Int
    let version: String
    let access: String
    let total: Int
    let data: [String: CountryData]
    
    enum CodingKeys: String, CodingKey {
        case status
        case statusCode = "status-code"
        case version
        case access
        case total
        case data
    }
}

struct CountryData: Decodable {
    let country: String
    let region: String
}

struct GetCountriesRequest: APIRequest {
    typealias Response = CountryResponse
    
    var baseURL: String { "https://api.first.org" }
    var path: String { "/data/v1/countries" }
    var method: HTTPMethod { .GET }
    var headers: [String: String]? { nil }
    var queryParams: [String: String]? { nil }
    var body: Data? { nil }
}
