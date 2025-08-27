//
//  SessionService.swift
//  UIKit-test-app
//
//  Created by Abduqaxxor Saidjonov on 27/08/25.
//

import Foundation
import Combine

final class SessionService: NSObject {

    static var shared = SessionService()
    
    private var session: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration)
    }
    private var task: URLSessionTask?

    private var arrayOFUndoneRequests: [Endpoint] = []
    private var refreshingToken: Bool = false
    
    override init() {
        super.init()
    }
    
    public func get<T:Decodable> (endpoint: Endpoint, objectType: T.Type, decodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase) -> AnyPublisher<T, Error> {
        let request = generateRequest(endpoint)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = decodingStrategy
        
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let urlResponse = response as? HTTPURLResponse else {
                    throw NetworkErrors.requestUnknownError
                }
                
                print("********************************")
                print("URL: \(request.url!.absoluteString)")
                print("TYPE: \(endpoint.method)")
                if let body = request.httpBody {
                    print("BODY: \(String(data: body, encoding: .utf8) ?? "")")
                }
                print("HEADERS: \(request.allHTTPHeaderFields!)")
                print("RESPONSE: \(data.prettyPrintedJSONString ?? "")")
                print("STATUS CODE: \(urlResponse.statusCode)")
                print("********************************")
                
                guard [200, 201, 202, 203, 204].contains(urlResponse.statusCode) else {
                    throw NetworkErrors.unExpectedError(urlResponse.statusCode)
                }
                
                return data
            }
            .decode(type: T.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    public func stop() {
        task?.cancel()
    }
    
    private func generateRequest(_ endpoint: Endpoint) -> URLRequest {
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.host
        components.port = Constants.Hosts.baseUrlPort
        components.path = endpoint.path
        components.queryItems = endpoint.params
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = endpoint.method.rawValue
        endpoint.headers.forEach { header in
            request.setValue(header.value, forHTTPHeaderField: header.field)
        }

        if endpoint.method.isUploadMethod {
            request.httpBody = endpoint.body.asData()
        }

        return request
    }
}
