//
//  MoviesTableViewController.swift
//  itunes-poc
//
//  Created by David Duarte on 10/08/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import UIKit
import RxSwift
import AVKit

class MoviesTableViewController: UITableViewController {
    let presenter = MoviesPresenter()
    let disposeBag = DisposeBag()
    var movies: [Movie] = []
    
    let searchBar:UISearchBar = UISearchBar()
    var haveSearched: Bool = false
    
    override func viewDidLoad() {
        self.tabBarItem.title = "Movies"
        super.viewDidLoad()
        subscribeToObserver(self.presenter.presenterMovieSubject)
        self.hideKeyboardWhenTappedAround()
        customizeSearchBar()
        self.tableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "movieCell")
    }
    
    func customizeSearchBar () {
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = " Buscar..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        self.navigationController?.navigationBar.backgroundColor = .blue
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
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "movieCell") as! MovieCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.default
        cell.movieNameString = movies[indexPath.row].trackName
        cell.artistNameString = movies[indexPath.row].longDescription
        cell.albumUImageURL = movies[indexPath.row].artworkUrl100
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 101
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.movies.count == 0 {
            if !haveSearched {
                tableView.setEmptyView(title: "Please, make a search :D", message: "")
            } else {
                tableView.setEmptyView(title: "We couldn't find this :(", message: "Please, make another search")
            }
        }
        return self.movies.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        presenter.playVideo(video: movies[indexPath.row], viewController: self)
        
        }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
}

extension MoviesTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchBarText = searchBar.text {
            self.haveSearched = true
            searchBar.resignFirstResponder()
            self.presenter.retrieveMovies(movie: searchBarText)
        }
    }
}

extension MoviesTableViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
    }
    
    @objc func hideKeyboard() {
        self.searchBar.resignFirstResponder()
    }
}
