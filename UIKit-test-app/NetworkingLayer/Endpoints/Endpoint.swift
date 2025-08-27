//
//  Endpoint.swift
//  UIKit-test-app
//
//  Created by Abduqaxxor Saidjonov on 27/08/25.
//

import Foundation

public typealias EndPointHeaders = [(value: String, field: String)]
public typealias Body = [String: Any]

public protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var body: Body { get }
    var params: [URLQueryItem] { get }
    var headers: EndPointHeaders { get }
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case patch = "PATCH"
    case put = "PUT"

    var isUploadMethod: Bool {
        switch self {
        case .post, .patch, .put:
            return true
        default:
            return false
        }
    }
}
