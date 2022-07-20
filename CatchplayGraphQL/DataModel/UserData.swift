//
//  UserData.swift
//  CatchplayGraphQL
//
//  Created by Ray Hsu on 2022/7/20.
//

import Foundation

struct User: Codable {
    let id: String?
    let name: String?
    let email: String?
    let todos: [Todo]?
}

struct UserData: Codable {
    let user: User
}

struct UsersData: Codable {
    let users: [User]
}

