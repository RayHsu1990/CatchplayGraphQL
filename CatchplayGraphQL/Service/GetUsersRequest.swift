//
//  GetUsersRequest.swift
//  CatchplayGraphQL
//
//  Created by Ray Hsu on 2022/7/20.
//

import Foundation

enum UserQueryKey {
    case id
    case email
    case name
    case todos(keys: [TodoQueryKey])
    
    var keyString: String {
        switch self {
        case .id: return "id"
        case .email: return "email"
        case .name: return "name"
        case .todos(let keys):
            return "todos {\n\(keys.map { $0.rawValue }.joined(separator: "\n"))\n }"
        }
    }
    
}

struct GetUsersRequest: GraphQLRequest {
    
    typealias Value = UsersData
    
    typealias QLError = GraphQLError
    
    let queryKeys: [String]
        
    private var query: String {
        return "{\n users \n { \(queryKeys.joined(separator: "\n")) \n } \n }"
    }
    
    init(queryKeys: [UserQueryKey]) {
        self.queryKeys = queryKeys.map { $0.keyString }
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
