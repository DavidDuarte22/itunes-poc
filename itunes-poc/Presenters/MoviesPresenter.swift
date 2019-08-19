//
//  SearcherPresenter.swift
//  itunes-poc
//
//  Created by David Duarte on 10/08/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import networkLayer
import RxSwift

class MoviesPresenter {
    
    var presenterMovieSubject = PublishSubject<[Movie]>()
    
    private let httpClient = HttpClient()
    private let itunesAPIURL =
   "https://itunes.apple.com/search?term=star+wars&media=movie"
    
    
    func retrieveMovies() {
        httpClient.callGet(
            serviceUrl: itunesAPIURL,
            success: { (arrayResult: MovieResults, response: HttpResponse?) in
                self.presenterMovieSubject.onNext(arrayResult.results!)
        },
            failure: { (error: Error, response: HttpResponse?) in
                self.presenterMovieSubject.onError(error)
        })
    }
    
    func showDetail(movie: Movie, navigationController: UINavigationController?) {
        //  let songViewController = SongViewController(song: song)
        //   navigationController?.pushViewController(songViewController, animated: true)
    }
}

