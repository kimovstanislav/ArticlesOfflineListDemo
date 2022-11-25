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
        return Future { promise in
            let articles: [APIModel.Response.Article] = self.getObject(fileName: MockJsonFiles.articlesList)
            promise(.success(articles))
        }.eraseToAnyPublisher()
    }
}

extension MockAPIClient {
    // TODO: process failure too, to test for parsing error?
    // Force all the casts for mock data. It's used for development purposes only.
    func getObject<T: Decodable>(fileName: String) -> T {
        let jsonString = JsonHelper.readJsonString(named: fileName)
        let data = jsonString.data(using: .utf8)!
        let decodeObject = try! JSONDecoder().decode(T.self, from: data)
        return decodeObject
        /*
        do {
            let jsonString = JsonHelper.readJsonString(named: fileName)
//            let measurementData = Data(measurementJson.utf8)
            let data = jsonString.data(using: .utf8)!
            let decodedData = try! JSONDecoder().decode(T.self, from: data)
        }
        catch {}
*/
    }
}
