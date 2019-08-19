//
//  SongPlayerController.swift
//  itunes-poc
//
//  Created by David Duarte on 15/08/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import UIKit
import AVFoundation

class SongPlayerController: UIViewController {
    let presenter = MusicPresenter()
    
    @IBOutlet weak var handleArea: UIView!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var playIcon: UIButton!
    
    // Action for play/stop button
    @IBAction func playAction(_ sender: Any) {
        if let previewURL = previewURL {
            let isPlaying = presenter.isPlayingMusic(previewURL: "\(previewURL)")
            if isPlaying {
                playIcon.setImage(UIImage(named: "stopicon"), for: .normal)
            } else {
                playIcon.setImage(UIImage(named: "playicon"), for: .normal)
            }
        }
    }
    
    @IBAction func previousAction(_ sender: Any) {
    }
    
    @IBAction func forwardAction(_ sender: Any) {
    }
    
    // inherited parameters
    var song: Music!
    var imageSong: UIImage!
    var previewURL: URL?
    
    @IBOutlet weak var songImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.trackName.text = song.trackName
        self.artistName.text = song.artistName
        self.previewURL = song.previewUrl
        self.songImageView.image = imageSong
        
    }
    required init(song: Music, image: UIImage) {
        self.song = song
        self.imageSong = image
        super.init(nibName: "SongPlayerController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
