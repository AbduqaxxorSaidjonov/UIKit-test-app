//
//  BaseEndpoints.swift
//  UIKit-test-app
//
//  Created by Abduqaxxor Saidjonov on 27/08/25.
//

import Foundation

public enum BaseEndpoints: Endpoint {
    case getTodos
    case getUsers
    
    public var scheme: String {
        return Constants.URLs.baseScheme
    }
    
    public var host: String {
        return Constants.URLs.baseURL
    }
    
    public var path: String {
        switch self {
            case .getTodos:
            return Constants.APIPaths.todos
        case .getUsers:
            return Constants.APIPaths.users
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    public var body: Body {
        return [:]
    }
    
    public var params: [URLQueryItem] {
        return []
    }
    
    public var headers: EndPointHeaders {
        return []
    }
}
