//
//  TodoData.swift
//  CatchplayGraphQL
//
//  Created by Ray Hsu on 2022/7/20.
//

import Foundation

struct TodosData: Codable {
    let todos: [Todo]
}

struct Todo: Codable {
    let id: String?
    let description: String?
    let done: Bool?
}

struct MutationTodoData: Codable {
    let updateTodo: Todo
}

enum TodoQueryKey: String {
    case id
    case description
    case done
}

