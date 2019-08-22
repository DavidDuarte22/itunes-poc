//
//  SearcherPresenter.swift
//  itunes-poc
//
//  Created by David Duarte on 10/08/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import networkLayer
import RxSwift
import AVKit

class MoviesPresenter {
    
    private var itunesAPIURL: String = ""
    
    init() {
        let value = Bundle.main.infoDictionary?["ITUNES_API_ENDPOINT"] as! String
        self.itunesAPIURL = value
    }
    var presenterMovieSubject = PublishSubject<[Movie]>()
    
    private let httpClient = HttpClient()
    
    
    // trim and replace whitespace in string inserted by user
    func prepareString(searchString: String) -> String {
        var polishedString = searchString.trimmingCharacters(in: .whitespacesAndNewlines)
        polishedString = polishedString.replacingOccurrences(of: " ", with: "+")
        return polishedString
    }
    
    func retrieveMovies(movie: String) {
        let searchText = prepareString(searchString: movie)
        httpClient.callGet(
            serviceUrl: "\(itunesAPIURL)?term=\(searchText)&media=movie",
            success: { (arrayResult: MovieResults, response: HttpResponse?) in
                self.presenterMovieSubject.onNext(arrayResult.results!)
        },
            failure: { (error: Error, response: HttpResponse?) in
                self.presenterMovieSubject.onError(error)
        })
    }
    
    func playVideo(video: Movie, viewController: UIViewController) {
        let video = AVPlayer(url: video.previewUrl!)
        
        let videoPlayer = AVPlayerViewController.init()
        videoPlayer.player = video
        
        viewController.present(videoPlayer, animated: true, completion: {
            video.play()
        })
    }
}

