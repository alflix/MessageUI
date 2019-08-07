//
//  Codable+.swift
//  Ganguo
//
//  Created by John on 2019/7/4.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import Foundation

public extension Decodable {
    /// Decodable 的封装初始化方法
    ///
    /// - Parameters:
    ///   - from: json
    ///   - dateFormat: 日期格式，可在 GGUI.CodableConfig.dateDecodingStrategy 中设置
    /// - Throws: 解析错误
    init(from: Any, dateFormat: String? = nil) throws {
        let data = try JSONSerialization.data(withJSONObject: from, options: .prettyPrinted)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        if let dateFormat = GGUI.CodableConfig.dateFormat {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
        } else {
            decoder.dateDecodingStrategy = GGUI.CodableConfig.dateDecodingStrategy
        }
        do {
            self = try decoder.decode(Self.self, from: data)
        } catch let error {
            DPrint(error.localizedDescription)
            throw error
        }
    }
}

public extension Encodable {
    /// Model->Dictionary（keyEncodingStrategy = .convertToSnakeCase ）
    ///
    /// - Returns: Dictionary
    /// - Throws: 转换错误
    func asDictionary() throws -> [String: Any] {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        if let dateFormat = GGUI.CodableConfig.dateFormat {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            encoder.dateEncodingStrategy = .formatted(dateFormatter)
        } else {
            encoder.dateEncodingStrategy = GGUI.CodableConfig.dateEncodingStrategy
        }
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }

    /// Model->JSONString（keyEncodingStrategy = .convertToSnakeCase ）
    ///
    /// - Returns: String
    /// - Throws: 转换错误
    func asJSONString() throws -> String? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        if let dateFormat = GGUI.CodableConfig.dateFormat {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            encoder.dateEncodingStrategy = .formatted(dateFormatter)
        } else {
            encoder.dateEncodingStrategy = GGUI.CodableConfig.dateEncodingStrategy
        }
        let data = try encoder.encode(self)
        guard let str = String(data: data, encoding: .utf8) else {
            throw NSError()
        }
        return str
    }
}
