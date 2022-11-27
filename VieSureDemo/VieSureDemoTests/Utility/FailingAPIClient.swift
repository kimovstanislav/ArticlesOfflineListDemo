//
//  FailingAPIClient.swift
//  VieSureDemoTests
//
//  Created by Stanislav Kimov on 28.11.22.
//

import Foundation
@testable import VieSureDemo

class FailingAPIClient: IVSAPI {
    func loadArticlesList() async throws -> [APIModel.Response.Article] {
        throw VSError.unknown
    }
}
