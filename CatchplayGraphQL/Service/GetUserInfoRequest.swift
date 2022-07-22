//
//  GetUserInfoRequest.swift
//  CatchplayGraphQL
//
//  Created by Ray Hsu on 2022/7/20.
//

import Foundation

struct GetUserInfoRequest: GraphQLRequest {
    typealias Value = UserData
    
    let userId: String
    
    let queryKeys: [String]
    let todosKeys: [String]?

    var query: String {
        return GraphQLQuery.query() {
            From("user")
            Arguments(Argument(key: "id", value: userId))
            Fields(queryKeys)
            SubQuery {
                From("todos")
                Fields(todosKeys)
            }
        }
    }
    
    init(queryKeys: [UserQueryKey], userId: String, todosKeys: [TodoQueryKey]?) {
        self.queryKeys = queryKeys.map { $0.rawValue }
        self.userId = userId
        self.todosKeys = todosKeys?.map { $0.rawValue }
    }
    
}
