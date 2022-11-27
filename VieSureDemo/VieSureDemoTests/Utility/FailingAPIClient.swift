//
//  FailingAPIClient.swift
//  VieSureDemoTests
//
//  Created by Stanislav Kimov on 28.11.22.
//

import Foundation
@testable import VieSureDemo

class FailingAPIClient: IVSAPI {
    // Can set any error we like
    var failingError: VSError = VSError.Factory.makeDecodingError(cause: nil)
    
    func loadArticlesList() async throws -> [APIModel.Response.Article] {
        throw failingError
    }
}
