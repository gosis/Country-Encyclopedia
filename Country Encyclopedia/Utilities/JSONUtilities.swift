//
//  JSONUtilities.swift
//  Country Encyclopedia
//
//  Created by Gints Osis on 20/02/2025.
//

import Foundation

class JSONUtilities {
    // MARK: - Encoding and Decoding Helpers
   public static func encodeArray<T: Encodable>(_ array: [T]?) -> String? {
       guard let array = array else { return nil }
       let encoder = JSONEncoder()
       if let jsonData = try? encoder.encode(array) {
           return String(data: jsonData, encoding: .utf8)
       }
       return nil
   }
   
    public static func decodeArray<T: Decodable>(_ jsonString: String?) -> [T]? {
       guard let json = jsonString, let jsonData = json.data(using: .utf8) else {
           return nil
       }
       let decoder = JSONDecoder()
       return try? decoder.decode([T].self, from: jsonData)
   }
   
    public static func encodeDict<T: Encodable>(_ dict: [String: T]) -> String? {
       let encoder = JSONEncoder()
       if let jsonData = try? encoder.encode(dict) {
           return String(data: jsonData, encoding: .utf8)
       }
       return nil
   }
   
    public static func decodeDict<T: Decodable>(_ jsonString: String?) -> [String: T]? {
       guard let json = jsonString, let jsonData = json.data(using: .utf8) else {
           return nil
       }
       let decoder = JSONDecoder()
       return try? decoder.decode([String: T].self, from: jsonData)
   }
}
