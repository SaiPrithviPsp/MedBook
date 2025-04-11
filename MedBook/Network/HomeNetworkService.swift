//
//  HomeNetworkService.swift
//  MedBook
//
//  Created by Sai Prithvi on 16/03/25.
//

import Foundation

protocol HomeNetworkServiceProtocol {
    func fetchBooks(query: String, limit: Int, offset: Int, completion: @escaping (Result<BookSearchResponse, Error>) -> Void)
    func fetchBookDetails(key: String, completion: @escaping (Result<GetBookDetailsResponse, Error>) -> Void)
}

class HomeNetworkService: HomeNetworkServiceProtocol {
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func fetchBooks(query: String, limit: Int, offset: Int, completion: @escaping (Result<BookSearchResponse, Error>) -> Void) {
        let request = SearchBooksRequest(title: query, limit: limit, offset: offset)
        networkManager.execute(request, completion: completion)
    }
    
    func fetchBookDetails(key: String, completion: @escaping (Result<GetBookDetailsResponse, Error>) -> Void) {
        let request = GetBookDetailsRequest(key: key)
        networkManager.execute(request, completion: completion)
    }
}

struct SearchBooksRequest: APIRequest {
    typealias Response = BookSearchResponse
    
    let title: String
    let limit: Int
    let offset: Int
    
    var baseURL: String { "https://openlibrary.org" }
    var path: String { "/search.json" }
    var method: HTTPMethod { .GET }
    var headers: [String: String]? { nil }
    var queryParams: [String: String]? {
        [
            "title": title,
            "limit": String(limit),
            "offset": String(offset)
        ]
    }
    var body: Data? { nil }
}

struct BookSearchResponse: Decodable {
    let numFound: Int
    let start: Int
    let docs: [Book]
}

struct GetBookDetailsRequest: APIRequest {
    typealias Response = GetBookDetailsResponse
    
    let key: String
    
    var baseURL: String { "https://openlibrary.org" }
    var path: String {
        "/works/\(key).json"
    }
    var method: HTTPMethod { .GET }
    var headers: [String: String]? { nil }
    var queryParams: [String: String]? { nil }
    var body: Data? { nil }
}

struct GetBookDetailsResponse: Decodable {
    let description: DynamicDescriptionValue
}

enum DynamicDescriptionValue: Decodable {
    case string(String)
    case object(BookDescription)
    
    // Custom decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        // Try decoding as a string first
        if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
            return
        }
        
        // Try decoding as a dictionary
        if let objectValue = try? container.decode(BookDescription.self) {
            self = .object(objectValue)
            return
        }
        
        throw DecodingError.typeMismatch(DynamicDescriptionValue.self, DecodingError.Context(
            codingPath: decoder.codingPath,
            debugDescription: "Value is neither a string nor a JSON object"
        ))
    }
}

struct BookDescription: Decodable {
    let value: String
}

struct Book: Decodable, Hashable {
    let title: String
    let key: String
    let ratingsAverage: Double?
    let ratingsCount: Int?
    let authorName: [String]?
    let coverI: Int?
    let firstPublishYear: Int?
    var description: String?
}

extension Book {
    func getImageUrl() -> String? {
        guard let imageId = self.coverI else { return nil }
        return "https://covers.openlibrary.org/b/id/\(imageId)-M.jpg"
    }
}
