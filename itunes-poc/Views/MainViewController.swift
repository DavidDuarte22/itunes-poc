//
//  MainViewController.swift
//  itunes-poc
//
//  Created by David Duarte on 11/08/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    
    override func viewDidLoad() {
        
        let musicTableView = MusicTableViewController()
        let moviesTableView = MoviesTableViewController()
        let tvShowTableView = TvShowTableViewController()
        
        musicTableView.tabBarItem = UITabBarItem(title: "Music", image: nil, tag: 0)
        musicTableView.tabBarItem.image = UIImage(named: "musicicon")
        musicTableView.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        moviesTableView.tabBarItem = UITabBarItem(title: "Movies", image: nil, tag: 1)
        moviesTableView.tabBarItem.image = UIImage(named: "movieicon")
        tvShowTableView.tabBarItem = UITabBarItem(title: "Tv Shows", image: nil, tag: 2)
        tvShowTableView.tabBarItem.image = UIImage(named: "tvshowicon")
        
        let controllers = [musicTableView, moviesTableView, tvShowTableView]
        
        viewControllers = controllers.map { UINavigationController(rootViewController: $0) }
        
    }
    
    
}
