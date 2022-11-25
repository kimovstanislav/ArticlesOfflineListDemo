//
//  MockAPIClient.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 25.11.22.
//

import Foundation
import Combine

class MockAPIClient: IVSAPI {
    enum MockJsonFiles {
        static let articlesList = "articles_list"
    }
    
    func articlesList() -> AnyPublisher<[APIModel.Response.Article], VSError> {
        return Future { [unowned self] promise in
            let result: Result<[APIModel.Response.Article], VSError> = self.getObject(fileName: MockJsonFiles.articlesList)
            promise(result)
        }.eraseToAnyPublisher()
    }
}

extension MockAPIClient {
    func getObject<T: Decodable>(fileName: String) -> Result<T, VSError> {
        do {
            let jsonString = JsonHelper.readJsonString(named: fileName)
            let data = jsonString.data(using: .utf8)!
            let decodeObject = try JSONDecoder().decode(T.self, from: data)
            return .success(decodeObject)
        }
        catch {
            let error: VSError = VSError.makeDecodingError()
            return .failure(error)
        }
    }
}
