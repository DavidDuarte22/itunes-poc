//
//  MusicPresenter.swift
//  itunes-poc
//
//  Created by David Duarte on 10/08/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import AVFoundation
import networkLayer
import RxSwift

class MusicPresenter {
    
    var presenterToMusicSubject = PublishSubject<[Music]>()
    
    private let httpClient = HttpClient()
    private let itunesAPIURL =
    "https://itunes.apple.com/search"
    
    var player : AVPlayer?
    var isPlaying = false
    // trim and replace whitespace in string inserted by user
    func prepareString(searchString: String) -> String {
        var polishedString = searchString.trimmingCharacters(in: .whitespacesAndNewlines)
        polishedString = polishedString.replacingOccurrences(of: " ", with: "+")
        return polishedString
    }
    // make http request to itunes API
    func retrieveMusic(artist: String) {
        let searchText = prepareString(searchString: artist)
        httpClient.callGet(
            serviceUrl: "\(itunesAPIURL)?term=\(searchText)&media=music",
            success: { (arrayResult: MusicResults, response: HttpResponse?) in
                self.presenterToMusicSubject.onNext(arrayResult.results!)
        },
            failure: { (error: Error, response: HttpResponse?) in
                self.presenterToMusicSubject.onError(error)
        })
    }
    // stop or play music
    func isPlayingMusic(previewURL: String) -> Bool {
        if isPlaying {
            player?.pause()
            return false
        } else {
            isPlaying = true
            guard let url = URL.init(string: previewURL) else { return true }
            let playerItem = AVPlayerItem.init(url: url)
            player = AVPlayer.init(playerItem: playerItem)
            player?.play()
            return true
        }
    }
}
