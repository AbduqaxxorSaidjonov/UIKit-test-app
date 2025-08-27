//
//  ErrorModel.swift
//  UIKit-test-app
//
//  Created by Abduqaxxor Saidjonov on 27/08/25.
//

import Foundation

enum NetworkErrors: Error {
    case requestUnknownError
    case unExpectedError(Int)
}
