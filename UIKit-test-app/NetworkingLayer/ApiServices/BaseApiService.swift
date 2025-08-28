//
//  BaseApiService.swift
//  UIKit-test-app
//
//  Created by Abduqaxxor Saidjonov on 27/08/25.
//

import Foundation
import Combine

struct BaseApiService {
    func getTodosList() -> AnyPublisher<[TodosModel]?, Error> {
        SessionService.shared.get(endpoint: BaseEndpoints.getTodos, objectType: [TodosModel]?.self)
    }
    
    func getUsersList() -> AnyPublisher<[User]?, Error> {
        SessionService.shared.get(endpoint: BaseEndpoints.getUsers, objectType: [User]?.self)
    }
}
