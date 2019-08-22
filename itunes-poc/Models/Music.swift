//
//  Music.swift
//  itunes-poc
//
//  Created by David Duarte on 08/08/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import Foundation

// MARK: - Music
class Music: Codable {
    var trackName: String?
    var artistName: String?
    var artworkUrl100: URL?
    var previewUrl: URL?
    var trackPrice: Double?
    var currency: String?
    init() {
        
    }
}

class MusicResults: Codable {
    var resultCount: Int?
    var results: [Music]?
    var trackPrice: Double?
    init() {
        
    }
    
}
