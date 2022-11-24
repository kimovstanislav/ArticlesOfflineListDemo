//
//  APIClient.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 22.11.22.
//

import Foundation
import Combine

protocol IVSAPI {
    func articlesList() -> AnyPublisher<[APIModel.Response.Article], VSError>
}
