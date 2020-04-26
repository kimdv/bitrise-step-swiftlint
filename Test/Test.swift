//
//  Test.swift
//  SwiftLint
//
//  Created by Kim de Vos on 8/19/17.
//  Copyright © 2017 Realm. All rights reserved.
//

import Foundation

extension Test {

    /// Failing example
    func getURL() -> URL {
        let url = URL(string: "some.string")!
        return url
    }

    /// Non-failing example
    func getURL() -> URL? {
        let url = URL(string: "some.string")
        return url
    }
}
