//
//  VSAPIClient.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 13.11.22.
//

import Foundation

class VSAPIClient: APIClient {
    /// GET 'https://run.mocky.io/v3/de42e6d9-2d03-40e2-a426-8953c7c94fb8'
    func getArticles(completion: @escaping CompletionResult<Data, VSError>) {
        // Could create a separate class with all urls and parameters as constant strings, but no need here for a single entry.
        guard let url = URL(string: "https://run.mocky.io/v3/de42e6d9-2d03-40e2-a426-8953c7c94fb8") else {
            unexpectedCodePath(message: "Invalid URL.")
        }
        genericGetRequest(url: url) { result in
            let clientResponse = VSAPIClient.Parser.parseResponse(from: result)
            completion(clientResponse)
        }
    }
}
