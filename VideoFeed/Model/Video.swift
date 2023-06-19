//
//  Video.swift
//  VideoFeed
//
//  Created by Al-Amin on 2023/06/19.
//

import Foundation

struct Video: Identifiable,Decodable {
    var id: String {
        return UUID().uuidString
    }
    let videoUrl: String
}
