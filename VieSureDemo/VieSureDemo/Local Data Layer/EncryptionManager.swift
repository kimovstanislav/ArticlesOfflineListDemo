//
//  EncryptionManager.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 24.11.22.
//

import Foundation
import Combine

// TODO: implementation later. - https://mukeshydv.medium.com/securing-users-data-in-ios-with-swift-9e2be41c3b31
// TODO: a better name?
class EncryptionManager {
    func encryptData(data: Data) -> AnyPublisher<Data, VSError> {
        return Future { promise in
            promise(.success(data))
        }.eraseToAnyPublisher()
    }
    
    
    func decryptData(data: Data) -> AnyPublisher<Data, VSError> {
        return Future { promise in
            promise(.success(data))
        }.eraseToAnyPublisher()
    }
}
