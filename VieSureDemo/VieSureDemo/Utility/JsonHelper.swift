//
//  JsonHelper.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 25.11.22.
//

import Foundation

enum JsonHelper {
    static func readJsonString(named: String) -> String {
        if let path = Bundle.main.path(forResource: named, ofType: "json") {
            return (try? String(contentsOfFile: path)) ?? ""
        }
        return ""
    }
}
