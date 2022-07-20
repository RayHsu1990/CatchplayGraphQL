//
//  GetUserInfoRequest.swift
//  CatchplayGraphQL
//
//  Created by Ray Hsu on 2022/7/20.
//

import Foundation

struct GetUserInfoRequest: GraphQLRequest {
    typealias Value = UserData
    
    typealias QLError = GraphQLError
    
    var queryKeys: [String]
    
    let id: String
    
    private var query: String {
        return """
                {
                    user(id: "\(id)") {
                        \(queryKeys.joined(separator: "\n"))
                    }
                }
                """
    }
    
    init(queryKeys: [UserQueryKey], id: String) {
        self.queryKeys = queryKeys.map { $0.keyString }
        self.id = id
    }
    
    func getURLRequest() -> URLRequest {
        var request = URLRequest(url: url)
        let parameters = ["query": query]
        let body = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        request.allHTTPHeaderFields = ["Content-type": "application/json"]
        request.httpMethod = HttpMethod.post.rawValue
        request.httpBody = body
        return request
    }

    func decode(_ data: Data?) -> Result<Value, QLError> {
        guard let data = data else {
            return .failure(.noData)
        }
        do {
            let value = try JSONDecoder().decode(GraphQLData<Value>.self, from: data)
            return value.data == nil ? .failure(.decodeFail) : .success(value.data!)
        }
        catch {
            return .failure(.decodeFail)
        }
    }
    
}
