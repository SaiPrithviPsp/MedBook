//
//  HomeNetworkService.swift
//  MedBook
//
//  Created by Sai Prithvi on 16/03/25.
//

import Foundation

protocol HomeNetworkServiceProtocol {
    func fetchBooks(query: String, limit: Int, offset: Int, completion: @escaping (Result<BookSearchResponse, Error>) -> Void)
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

struct Book: Decodable, Hashable {
    let title: String
    let ratingsAverage: Double?
    let ratingsCount: Int?
    let authorName: [String]?
    let coverI: Int?
    let firstPublishYear: Int?
}
