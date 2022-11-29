//
//  IEncryption.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 28.11.22.
//

import Foundation

protocol IEncryption {
    func encryptData(data: Data) async throws -> Data
    func decryptData(data: Data) async throws -> Data
}
