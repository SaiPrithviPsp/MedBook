//
//  NetworkService.swift
//  MedBook
//
//  Created by Sai Prithvi on 16/03/25.
//


import Foundation

protocol UserNetworkServiceProtocol {
    func fetchUser(userId: Int, completion: @escaping (Result<UserResponse, Error>) -> Void)
    func fetchCountries(completion: @escaping (Result<CountryResponse, Error>) -> Void)
}

class UserNetworkService: UserNetworkServiceProtocol {
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func fetchUser(userId: Int, completion: @escaping (Result<UserResponse, Error>) -> Void) {
        let request = GetUserRequest(userId: userId)
        networkManager.execute(request, completion: completion)
    }
    
    func fetchCountries(completion: @escaping (Result<CountryResponse, Error>) -> Void) {
        let request = GetCountriesRequest()
        networkManager.execute(request, completion: completion)
    }
}

struct GetUserRequest: APIRequest {
    typealias Response = UserResponse
    
    let userId: Int

    var baseURL: String { "https://jsonplaceholder.typicode.com" }
    var path: String { "/users/\(userId)" }
    var method: HTTPMethod { .GET }
    var headers: [String: String]? { nil }
    var queryParams: [String: String]? { nil }
    var body: Data? { nil }
}

struct UserResponse: Decodable {
    let id: Int
    let name: String
    let username: String
    let email: String
}


