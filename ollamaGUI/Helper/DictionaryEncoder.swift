//
//  DictionaryEncoder.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/12/24.
//

import Foundation

class DictionaryEncoder {
    private let encoder = JSONEncoder()

    func encode<T>(_ value: T) throws -> [String: Any] where T : Encodable {
        let data = try encoder.encode(value)
        return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
    }
}


extension Encodable{
    func getLeafDictionary() -> [String:Any]?{
        let data = try? JSONEncoder().encode(self)
        let dict = try? JSONSerialization.jsonObject(with: data!) as? [String: Any]
        return dict
    }
}

protocol DictionaryEncodable{
    func getDictionary()->[String:Any]?
}
