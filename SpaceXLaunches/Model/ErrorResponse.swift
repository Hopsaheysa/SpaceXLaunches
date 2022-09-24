//
//  ErrorResponse.swift
//  SpaceXLaunches
//
//  Created by Marek Stransky on 24.09.2022.
//

import Foundation

enum ErrorResponse {
    case noData, decodingFail, requestFail, unknownFail
}

extension ErrorResponse: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noData: return "Error: did not receive data"
        case .decodingFail: return "Error: Data decoding failed"
        case .requestFail: return "Error: HTTP request failed"
        case .unknownFail: return "Fail: Unknown error"
        }
    }
}
