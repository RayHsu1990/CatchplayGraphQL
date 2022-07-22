//
//  Request.swift
//  CatchplayGraphQL
//
//  Created by Ray Hsu on 2022/7/20.
//

import Foundation

protocol Request {
    var url: URL { get }
    func getURLRequest() -> URLRequest
}

protocol GraphQLRequest: Request {
    associatedtype Value: Codable
    var url: URL { get }
    var httpMethod: HttpMethod { get }
    var query: String { get }
    
    func convertError(_ data: Data?, _ res: URLResponse?, _ error: Error?) -> Error?
    func decode(_ data: Data?) -> Result<Value, Error>
}

extension GraphQLRequest {
    
    var url: URL {
        return URL(string: "https://api.mocki.io/v2/c4d7a195/graphql")!
    }
    
    var httpMethod: HttpMethod {
        return .post
    }
    
    func getURLRequest() -> URLRequest {
        var request = URLRequest(url: url)
        let parameters = ["query": query]
        let body = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        request.allHTTPHeaderFields = ["Content-type": "application/json"]
        request.httpMethod = httpMethod.rawValue
        request.httpBody = body
        return request
    }
    
    func convertError(_ data: Data?, _ res: URLResponse?, _ error: Error?) -> Error? {
        if error != nil {
            return GraphQLError.defaultError
        }
        if data == nil {
            return GraphQLError.noData
        }
        return nil
    }
    
    func decode(_ data: Data?) -> Result<Value, Error> {
        guard let data = data else {
            return .failure(GraphQLError.noData)
        }
        do {
            let value = try JSONDecoder().decode(GraphQLData<Value>.self, from: data)
            guard let data = value.data else {
                return .failure(GraphQLError.noData)
            }
            return .success(data)
        }
        catch {
            return .failure(GraphQLError.decodeFail)
        }
    }
    
}

enum HttpMethod: String {
    case post = "POST"
    case get = "GET"
}

enum GraphQLError: Error {
    case defaultError
    case noData
    case decodeFail
}
