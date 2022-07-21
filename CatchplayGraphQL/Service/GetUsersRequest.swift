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
    
    let queryKeys: [String]
        
    var query: String {
        return "{\n users \n { \(queryKeys.joined(separator: "\n")) \n } \n }"
    }
    
    init(queryKeys: [UserQueryKey]) {
        self.queryKeys = queryKeys.map { $0.keyString }
    }
    
}
