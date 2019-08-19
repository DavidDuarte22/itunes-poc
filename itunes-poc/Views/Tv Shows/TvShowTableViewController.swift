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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem.title = "TvShow"
        subscribeToObserver(self.presenter.presenterToTvShowSubject)
        presenter.retrieveTvShows()
        // Do any additional setup after loading the view.
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
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "MusicCell")
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tvShows.count
    }
}
