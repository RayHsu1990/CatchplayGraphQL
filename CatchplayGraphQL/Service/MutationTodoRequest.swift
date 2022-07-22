//
//  MutationTodoRequest.swift
//  CatchplayGraphQL
//
//  Created by Ray Hsu on 2022/7/21.
//

import Foundation

struct MutationTodoRequest: GraphQLRequest {
    typealias Value = MutationTodoData
    
    var queryKeys: [String]
    
    let id: String?
    
    let description: String?
    
    let done: Bool
    
    var query: String {
        return GraphQLQuery.query() {
            QueryTitle(title: "mutation")
            From("updateTodo")
            Arguments(Argument(key: "input", subArguments: [
                Argument(key: "id", value: id),
                Argument(key: "description", value: description),
                Argument(key: "done", value: done)
            ]))
            
            Fields(queryKeys)
        }
    }
    
    init(queryKeys: [TodoQueryKey], id: String?, description: String?, done: Bool) {
        self.queryKeys = queryKeys.map { $0.rawValue }
        self.id = id
        self.description = description
        self.done = done
    }
    
    private func getInputQuery() -> String {
        var query = ""
        if let id = id {
            let str = """
                    id: "\(id)", 
                    """
            query.append(str)
        }
        if let description = description {
            query.append("description: \"\(description)\", ")
        }
         
        query.append("done: \(String(done))")
        
        return query
    }
}
