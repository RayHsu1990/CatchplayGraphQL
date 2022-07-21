//
//  GraphQLData.swift
//  CatchplayGraphQL
//
//  Created by Ray Hsu on 2022/7/20.
//

import Foundation

/// graphQL的第一層資料結構都是data:
struct GraphQLData<T: Codable>: Codable {
    typealias Value = T
    var data: Value?
}
