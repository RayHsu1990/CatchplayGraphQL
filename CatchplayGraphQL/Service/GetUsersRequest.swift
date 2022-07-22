//
//  GetUsersRequest.swift
//  CatchplayGraphQL
//
//  Created by Ray Hsu on 2022/7/20.
//

import Foundation

struct GetUsersRequest: GraphQLRequest {
    
    typealias Value = UsersData
    
    let queryKeys: [String]
    
    let todoQueries: [String]?
        
    var query: String {
        return GraphQLQuery.query() {
            From("users")
            Fields(queryKeys)
            SubQuery {
                From("todos")
                Fields(todoQueries)
            }
        }
    }
    
    init(queryKeys: [UserQueryKey], todoQueries: [TodoQueryKey]?) {
        self.queryKeys = queryKeys.map { $0.rawValue }
        self.todoQueries = todoQueries?.map { $0.rawValue }
    }
    
}
