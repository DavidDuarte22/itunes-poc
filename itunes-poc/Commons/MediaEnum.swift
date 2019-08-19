////
////  MediaEnum.swift
////  itunes-poc
////
////  Created by David Duarte on 06/08/2019.
////  Copyright © 2019 David Duarte. All rights reserved.
////
//
//import Foundation
//
//enum Media {
//    
//    case music(song: Music)
//    case movie(movie: Movie)
//}
//
//class Results: Codable {
//    var resultCount: Int
//    var results: [Media]
//    
//}
//
//// MARK: - Music
//class Music: Codable {
//    var trackName: String
//    var artistName: String
//    var artworkUrl100: URL
//    
//    enum CodingKeys: String, CodingKey {
//        case trackName = "trackName"
//        case artistName = "artistName"
//        case artworkUrl100 = "artworkUrl100"
//    }
//    
//    required init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        self.trackName = try values.decode(String.self, forKey: .trackName)
//        self.artistName = try values.decode(String.self, forKey: .artistName)
//        self.artworkUrl100 = try values.decode(URL.self, forKey: .artworkUrl100)
//    }
//}
//
//
//extension Media: Encodable {
//    enum CodingKeys: CodingKey {
//        case music, movie
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        switch self {
//        case .music(let value):
//            try container.encode(value, forKey: .music)
//        case .movie(let value):
//            try container.encode(value, forKey: .movie)
//        }
//    }
//}
//
//extension Media: Decodable {
//    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        do {
//            if let musicValue = try container.nestedContainer(keyedBy: Music.self, forKey: .music) {
//                self = .music(song: musicValue)
//            } else if let movieValue = try container.nestedContainer(keyedBy: Movie.self, forKey: .movie) {
//                self = .movie(movie: movieValue)
//            }
//        } catch {
//            print(error)
//        }
//        
//    }
//    
//    
//}
//
////In case of 'tvShow': show artistName, trackName, artworkUrl100 and the
////longDescription.
////- In case of 'movie': show trackName, artworkUrl100 and longDescription.
////- In case of 'music': show trackName, artistName and artworkUrl100.
