//
//  GetUserInfoRequest.swift
//  CatchplayGraphQL
//
//  Created by Ray Hsu on 2022/7/20.
//

import Foundation

struct GetUserInfoRequest: GraphQLRequest {
    typealias Value = UserData
    
    let queryKeys: [String]
    
    let id: String
    
    var query: String {
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
    
}
