//
//  Util.swift
//  SpaceXLaunches
//
//  Created by Marek Stransky on 24.10.2022.
//

import Foundation

class FileUtils {
    static func getTempDirectory() -> URL? {
        return try? FileManager.default.url(for: .itemReplacementDirectory,
                                           in: .userDomainMask,
                                           appropriateFor: FileManager.default.temporaryDirectory,
                                           create: true)
    }
    
    static func saveImage(_ data: Data, to folderUrl: URL, named hashString: String) throws {
        if FileManager.default.fileExists(atPath: folderUrl.path) {
            try data.write(to: folderUrl.appendingPathComponent("\(hashString).jpg"))
        }
    }
}


