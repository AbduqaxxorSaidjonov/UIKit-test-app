//
//  TodosMdoel.swift
//  UIKit-test-app
//
//  Created by Abduqaxxor Saidjonov on 27/08/25.
//

import Foundation

struct TodosModel: Decodable {
    let userId: Int?
    let id: Int?
    let title: String?
    let completed: Bool?
    
    var titleUnwrapped: String {
        return title ?? "no title"
    }
    
    var user: User?
}
