//
//  TvShow.swift
//  itunes-poc
//
//  Created by David Duarte on 08/08/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import Foundation

// MARK: - TvShow
class TvShow: Codable {
    var artistName: String?
    var trackName: String?
    var artworkUrl100: URL?
    
    init() {
        
    }
}

class TvShowResults: Codable {
    var resultCount: Int?
    var results: [TvShow]?
    
    init() {
        
    }
    
}
