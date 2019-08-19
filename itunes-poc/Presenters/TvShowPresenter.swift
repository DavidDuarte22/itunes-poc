//
//  TvShowPresenter.swift
//  itunes-poc
//
//  Created by David Duarte on 10/08/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import networkLayer
import RxSwift

class TvShowPresenter {
    
    var presenterToTvShowSubject = PublishSubject<[TvShow]>()
    
    private let httpClient = HttpClient()
    private let itunesAPIURL =
    "https://itunes.apple.com/search?term=star+wars&media=movie"
    
    
    func retrieveTvShows() {
        httpClient.callGet(
            serviceUrl: itunesAPIURL,
            success: { (arrayResult: TvShowResults, response: HttpResponse?) in
                self.presenterToTvShowSubject.onNext(arrayResult.results!)
        },
            failure: { (error: Error, response: HttpResponse?) in
                self.presenterToTvShowSubject.onError(error)
        })
    }
}
