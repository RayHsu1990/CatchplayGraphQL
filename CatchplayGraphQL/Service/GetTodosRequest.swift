//
//  GetTodosRequest.swift
//  CatchplayGraphQL
//
//  Created by Ray Hsu on 2022/7/20.
//

import Foundation

enum TodoQueryKey: String, CaseIterable {
    case id
    case description
    case done
}

struct GetTodosRequest: GraphQLRequest {
    typealias Value = TodosData
    
    typealias QLError = GraphQLError
    
    var queryKeys: [String]
    
    private var query: String {
        return """
                {
                    todos {
                        \(queryKeys.joined(separator: "\n"))
                    }
                }
                """
    }
    
    init(queryKeys: [TodoQueryKey]) {
        self.queryKeys = queryKeys.map { $0.rawValue }
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
