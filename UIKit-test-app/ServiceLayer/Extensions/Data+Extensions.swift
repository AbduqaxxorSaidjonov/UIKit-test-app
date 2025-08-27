//
//  Data+Extensions.swift
//  UIKit-test-app
//
//  Created by Abduqaxxor Saidjonov on 27/08/25.
//

import Foundation

extension Data {
    var prettyPrintedJSONString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
                  let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]) else {
                return nil
            }
        return String(data: data, encoding: .utf8)
    }
    
    func toDictionary() -> [String: Any]? {
        return try? JSONSerialization.jsonObject(with: self, options: .allowFragments) as? [String: Any]
    }
}

extension Dictionary {
    func asData() -> Data {
        let serializableDictionary = filter { key, value in
            JSONSerialization.isValidJSONObject([key, value])
        }
        if serializableDictionary.isEmpty {
            return Data()
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: serializableDictionary, options: .fragmentsAllowed)
            return data
        } catch let error {
            print(error.localizedDescription)
            return Data()
        }
    }
}
