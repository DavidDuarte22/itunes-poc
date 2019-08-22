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
    
    var presenterTvShowSubject = PublishSubject<[TvShow]>()
    
    private let httpClient = HttpClient()
    private var itunesAPIURL: String = ""
    
    init() {
        let value = Bundle.main.infoDictionary?["ITUNES_API_ENDPOINT"] as! String
        self.itunesAPIURL = value
    }
    
    // trim and replace whitespace in string inserted by user
    func prepareString(searchString: String) -> String {
        var polishedString = searchString.trimmingCharacters(in: .whitespacesAndNewlines)
        polishedString = polishedString.replacingOccurrences(of: " ", with: "+")
        return polishedString
    }
    
    func retrieveTvShow(tvShow: String) {
        let searchText = prepareString(searchString: tvShow)
        httpClient.callGet(
            serviceUrl: "\(itunesAPIURL)?term=\(searchText)&media=tvShow",
            success: { (arrayResult: TvShowResults, response: HttpResponse?) in
                self.presenterTvShowSubject.onNext(arrayResult.results!)
        },
            failure: { (error: Error, response: HttpResponse?) in
                self.presenterTvShowSubject.onError(error)
        })
    }
}
