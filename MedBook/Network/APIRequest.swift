//
//  APIRequest.swift
//  MedBook
//
//  Created by Sai Prithvi on 16/03/25.
//

import Foundation

protocol APIRequest {
    associatedtype Response: Decodable
    
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryParams: [String: String]? { get }
    var body: Data? { get }
    
    func buildURLRequest() -> URLRequest?
}

extension APIRequest {
    func buildURLRequest() -> URLRequest? {
        guard var urlComponents = URLComponents(string: baseURL + path) else {
            return nil
        }
        
        if let queryParams = queryParams {
            urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = urlComponents.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        
        return request
    }
}

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}
