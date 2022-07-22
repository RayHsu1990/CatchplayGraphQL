//
//  Extension + String.swift
//  CatchplayGraphQL
//
//  Created by Ray Hsu on 2022/7/22.
//

import Foundation

extension String {
    func removeSpace() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
}
