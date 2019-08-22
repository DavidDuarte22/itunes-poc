//
//  MusicTableViewController.swift
//  itunes-poc
//
//  Created by David Duarte on 10/08/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import UIKit
import RxSwift

class MusicTableViewController: UITableViewController {
    let presenter = MusicPresenter()
    let disposeBag = DisposeBag()
    var songs: [Music] = []
    
    let searchBar:UISearchBar = UISearchBar()
    var haveSearched: Bool = false
    let spinner = SpinnerViewController()
    
    var nextState: SongPlayerState {
        return songPlayerVisible ? .collapsed : .expanded
    }
    
    // Variable for song player view controller
    var songViewController:SongPlayerController!
    
    // Variable for effects visual effect view
    var visualEffectView:UIVisualEffectView!
    
    // Starting and end card heights will be determined later
    var endPlayerHeight:CGFloat = 0
    var startPlayerHeight:CGFloat = 0
    
    // Current visible state of the card
    var songPlayerVisible = false

    // Empty property animator array
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        customizeSearchBar()
        self.tableView.register(UINib(nibName: "MusicCell", bundle: nil), forCellReuseIdentifier: "musicCell")
        subscribeToObserver(self.presenter.presenterToMusicSubject)
        
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
    
    func subscribeToObserver (_ subject: PublishSubject<[Music]>) {
        subject.subscribe(
            onNext: {(songs) in
                self.songs = songs
                self.spinner.willMove(toParent: nil)
                self.spinner.view.removeFromSuperview()
                self.spinner.removeFromParent()
                self.tableView.reloadData()
        },
            onError: {(error) in
                print(error)
        }).disposed(by: disposeBag)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "musicCell") as! MusicCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.default
        cell.trackNameString = songs[indexPath.row].trackName
        cell.artistNameString = songs[indexPath.row].artistName
        cell.albumUImageURL = songs[indexPath.row].artworkUrl100
        
        if let price = songs[indexPath.row].trackPrice {
            let price = price as NSNumber
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale(identifier: "en_US")
            cell.priceString = formatter.string(from: price)
            return cell
        } else {
            cell.buyButton.isHidden = true
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.songs.count == 0 {
            if !haveSearched {
                tableView.setEmptyView(title: "Please, make a search :D", message: "")
            } else {
                tableView.setEmptyView(title: "We couldn't find this :(", message: "Please, make another search")
            }
        }
        return self.songs.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MusicCell
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.tableView.isScrollEnabled = false
        self.tableView.allowsSelection = false
        showModal(song: songs[indexPath.row], image: cell.albumImage.image!)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

extension MusicTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchBarText = searchBar.text {
            self.haveSearched = true
            searchBar.resignFirstResponder()
            self.presenter.retrieveMusic(artist: searchBarText)
            addChild(spinner)
            spinner.view.frame = view.frame
            view.addSubview(spinner.view)
            spinner.didMove(toParent: self)
        }
    }
}

extension MusicTableViewController {
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
