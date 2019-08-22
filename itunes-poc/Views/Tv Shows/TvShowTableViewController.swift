//
//  TvShowTableViewController.swift
//  itunes-poc
//
//  Created by David Duarte on 10/08/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import UIKit
import RxSwift

class TvShowTableViewController: UITableViewController {
    let presenter = TvShowPresenter()
    let disposeBag = DisposeBag()
    var tvShows: [TvShow] = []
    
    let searchBar:UISearchBar = UISearchBar()
    var haveSearched: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem.title = "Tv Shows"
        self.tableView.register(UINib(nibName: "TvShowCell", bundle: nil), forCellReuseIdentifier: "tvShowCell")
        subscribeToObserver(self.presenter.presenterTvShowSubject)
        customizeSearchBar()
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
    
    func subscribeToObserver (_ subject: PublishSubject<[TvShow]>) {
        subject.subscribe(
            onNext: {(tvShows) in
                self.tvShows = tvShows
                self.tableView.reloadData()
        },
            onError: {(error) in
                print(error)
        }).disposed(by: disposeBag)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "tvShowCell") as! TvShowCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.default
        cell.dateString = tvShows[indexPath.row].artistName
        cell.titleString = tvShows[indexPath.row].trackName
        cell.showUImageURL = tvShows[indexPath.row].artworkUrl100
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tvShows.count == 0 {
            if !haveSearched {
                tableView.setEmptyView(title: "Please, make a search :D", message: "")
            } else {
                tableView.setEmptyView(title: "We couldn't find this :(", message: "Please, make another search")
            }
        }
        return self.tvShows.count
    }
}

extension TvShowTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchBarText = searchBar.text {
            self.haveSearched = true
            searchBar.resignFirstResponder()
            self.presenter.retrieveTvShow(tvShow: searchBarText)
        }
    }
}

extension TvShowTableViewController {
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
