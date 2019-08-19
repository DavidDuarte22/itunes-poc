//
//  Movie.swift
//  itunes-poc
//
//  Created by David Duarte on 08/08/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import Foundation

// MARK: - Movie
class Movie: Codable {
    var trackName: String?
    var artworkUrl100: URL?
    var longDescription: String?
    
    init() {
        
    }
}

class MovieResults: Codable {
    var resultCount: Int?
    var results: [Movie]?
    
    init() {
        
    }
    
}
