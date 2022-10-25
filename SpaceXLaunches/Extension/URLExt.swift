//
//  URLExt.swift
//  SpaceXLaunches
//
//  Created by Marek Stransky on 24.10.2022.
//

import Foundation
import CryptoKit

extension URL {
    static func hashedAbsolutedString(from url: URL) -> String? {
        guard let urlData = url.absoluteString.data(using: .utf8) else { return nil }
        let hash = Insecure.MD5.hash(data: urlData)
        return hash.map { String(format: "%02hhx", $0) }.joined()
    }
}
