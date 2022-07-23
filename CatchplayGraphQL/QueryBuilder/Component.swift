//
//  Component.swift
//  CatchplayGraphQL
//
//  Created by Ray Hsu on 2022/7/22.
//

import Foundation

protocol Component {
    var string: String { get }
    var components: [String] { get }
    var arguments: [Argument]? { get }
}

struct From: Component {
    let string: String
    
    let components: [String]
    
    let arguments: [Argument]?
    
    init(_ string: String) {
        self.init(string: string, components: [], arguments: nil)
    }
    
    private init(string: String, components: [String], arguments: [Argument]?) {
        self.string = string
        self.components = components
        self.arguments = arguments
    }
    
    func fields(_ fields: String...) -> Component {
        From(string: string, components: fields, arguments: nil)
    }
    
    func arguments(_ arguments: Argument...) -> Component {
        From(string: string, components: components, arguments: arguments)
    }
    
}

struct Argument {
    
    var description: String
    
    init(key: String, value: String?) {
        guard let value = value else {
            description = ""
            return
        }

        self.description = "\(key):\"\(value)\""
    }
    
    init(key: String, value: Bool) {
        self.description = "\(key):\(value)"
    }
    
    init(subQuery: SubQuery) {
        description = subQuery.string
    }
    
    init(key: String, subArguments: [Argument]) {
        self.description = "\(key):{\(subArguments.map {$0.description}.joined(separator: ","))}"
    }
}

struct SubQuery: Component {
    var string: String
    
    var components: [String] = []
    
    var arguments: [Argument]? = nil
    
    init(@GraphQLBuilder builder: () -> String) {
        let query = builder().split(separator: "\n").dropFirst().dropLast().joined(separator: "\n")
        
        self.string = query
    }
    
}

struct QueryTitle: Component {
    var string: String
    
    var components: [String] = []
    
    var arguments: [Argument]? = nil
    
    init(title: String) {
        string = title
    }
}

struct Fields: Component {
    let string: String = ""
    
    var components: [String]
    
    var arguments: [Argument]? = nil
    
    init(_ components: String...) {
        self.components = components
    }
    
    init(_ components: [String]?) {
        self.components = components ?? []
    }
}

struct Arguments: Component {
    let string: String = ""
    
    let components: [String]
    
    var arguments: [Argument]? = nil
    
    init(_ arguments: Argument...) {
        self.components = arguments.map { $0.description }
    }
}

