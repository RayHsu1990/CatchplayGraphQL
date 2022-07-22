//
//  QueryBuilder.swift
//  CatchplayGraphQL
//
//  Created by Ray Hsu on 2022/7/21.
//

import Foundation

class QueryBuilder {
    private var title: String = ""
    
    var query: Query
    
    init(from: String) {
        self.query = Query(from: from)
    }
       
    @discardableResult
    func with(arguments: [String]) -> Self {
        guard !arguments.isEmpty else { return self }
        query.with(arguments: arguments)
        return self
    }
    
    @discardableResult
    func with(fields: [String]) -> Self {
        guard !fields.isEmpty else { return self }
        query.with(fields: fields)
        return self
    }
    
    @discardableResult
    func with(subQuery query: String) -> Self {
        guard !query.isEmpty else { return self }
        self.query.with(queries: [query])
        return self
    }
    
    @discardableResult
    func with(title: String?) -> Self {
        self.title = title ?? ""
        return self
    }
        
    func build() -> String {
        guard !query.from.isEmpty, !query.fields.isEmpty else { return "" }
        return "\(title){\n" + query.build() + "\n}"
    }
        
}


class Query {
    
    var from: String
    var arguments: [String] = []
    var fields: [String] = []
    var subQueries: [String] = []
    
    init(from: String) {
        self.from = from
    }
        
    func with(arguments: [String]) {
        self.arguments += arguments
    }
    
    func with(fields: [String]?) {
        guard let fields = fields else { return }
        self.fields += fields
    }
        
    func with(queries: [String]) {
        self.subQueries += queries
    }
    
    func build() -> String {
        var query = from + buildArguments() + "{\n" + buildFields()
        
        if subQueries.isEmpty {
            query += "\n}"
        } else {
            query += "\n"
            query += "\(buildSubQueries())\n}"
        }
        return query
    }
        
    private func buildArguments() -> String {
        if arguments.isEmpty {
            return ""
        }
        return "(" + arguments.joined(separator: ", ") + ")"
    }

    private func buildFields() -> String {
        fields.joined(separator: "\n")
    }
        
    private func buildSubQueries() -> String {
        subQueries.map { subQuery in
            subQuery.split(separator: "\n").joined(separator: "\n")
        }.joined(separator: "\n")
    }
    
}
