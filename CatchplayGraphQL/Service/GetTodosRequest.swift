//
//  GetTodosRequest.swift
//  CatchplayGraphQL
//
//  Created by Ray Hsu on 2022/7/20.
//

import Foundation

struct GetTodosRequest: GraphQLRequest {
    typealias Value = TodosData
    
    let queryKeys: [String]
    
    var query: String {
        return GraphQLQuery.query() {
            From("todos")
            Fields(queryKeys)
        }
    }
    
    init(queryKeys: [TodoQueryKey]) {
        self.queryKeys = queryKeys.map { $0.rawValue }
    }

}
