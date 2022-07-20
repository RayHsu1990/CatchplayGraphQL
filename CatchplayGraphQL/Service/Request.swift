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
    associatedtype QLError: Error
    var queryKeys: [String] { get }
    
    func convertError(_ data: Data?, _ res: URLResponse?, _ error: Error?) -> QLError?
    func decode(_ data: Data?) -> Result<Value, QLError>
}

extension GraphQLRequest {
    
    var url: URL {
        return URL(string: "https://api.mocki.io/v2/c4d7a195/graphql")!
    }
    
    func convertError(_ data: Data?, _ res: URLResponse?, _ error: Error?) -> GraphQLError? {
        if error != nil {
            return .defaultError
        }
        if data == nil {
            return .noData
        }
        return nil
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
