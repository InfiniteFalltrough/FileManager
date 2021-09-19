//
//  Data.swift
//  FileManagerExample
//
//  Created by Viktor Golubenkov on 14.09.2021.
//

import Foundation

struct SomeData: Codable, Hashable, Identifiable {
    
    var id = UUID()
    let text: String
    let date: Date
}
