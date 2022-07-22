//
//  GraphQLBuilder.swift
//  CatchplayGraphQL
//
//  Created by Ray Hsu on 2022/7/22.
//

import Foundation

struct GraphQLQuery {
    static func query(@GraphQLBuilder builder: () -> String) -> String {
        builder()
    }
}


@resultBuilder
struct GraphQLBuilder {
    
    static func buildBlock(_ components: Component...) -> String {
        let title = components
            .filter { $0 is QueryTitle }
            .first?.string
        let from = components
            .filter { $0 is From }
        let arguments = components
            .filter { $0 is Arguments }
            .flatMap(\.components)
        let subQueries = components
            .filter { $0 is SubQuery }
        
        let fields = components
            .filter { $0 is Fields }
            .flatMap(\.components)

        let queryBuilder = QueryBuilder(from: from.first?.string ?? "")
            .with(title: title)
            .with(fields: fields)
            .with(arguments: arguments)
            .with(subQuery: subQueries.first?.string ?? "")
        
        return queryBuilder.build()
    }
    
}
