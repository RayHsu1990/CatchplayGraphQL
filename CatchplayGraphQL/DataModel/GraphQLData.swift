//
//  GraphQLData.swift
//  CatchplayGraphQL
//
//  Created by Ray Hsu on 2022/7/20.
//

import Foundation

struct GraphQLData<T: Codable>: Codable {
    typealias Value = T
    var data: Value?
}
