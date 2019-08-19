//
//  MoviesTableViewController.swift
//  itunes-poc
//
//  Created by David Duarte on 10/08/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import UIKit
import RxSwift

class MoviesTableViewController: UITableViewController {
    let presenter = MoviesPresenter()
    let disposeBag = DisposeBag()
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        self.tabBarItem.title = "Movies"
        super.viewDidLoad()
        subscribeToObserver(self.presenter.presenterMovieSubject)
        presenter.retrieveMovies()
        // Do any additional setup after loading the view.
    }
    
    
    func subscribeToObserver (_ subject: PublishSubject<[Movie]>) {
        subject.subscribe(
            onNext: {(movies) in
                self.movies = movies
                self.tableView.reloadData()
        },
            onError: {(error) in
                print(error)
        }).disposed(by: disposeBag)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "MusicCell")
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
}
