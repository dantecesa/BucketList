//
//  Location.swift
//  BucketList
//
//  Created by Dante Cesa on 2/10/22.
//

import Foundation

struct Location: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var description: String
    let latitude: Double
    let longitude: Double
}
