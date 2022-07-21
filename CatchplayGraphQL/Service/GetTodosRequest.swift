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
    
    let queryKeys: [String]
    
    var query: String {
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

}
