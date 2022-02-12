//
//  FileManager-DocumentsDirectory.swift
//  BucketList
//
//  Created by Dante Cesa on 2/11/22.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
}
