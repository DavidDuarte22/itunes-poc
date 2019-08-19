//
//  MusicTableViewCell.swift
//  itunes-poc
//
//  Created by David Duarte on 11/08/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import UIKit

class MusicCell: UITableViewCell {
    
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var albumImage: UIImageView!
    
    var trackNameString : String?
    var artistNameString: String?
    var albumUImageURL: URL?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        if let trackNameString = trackNameString {
            self.trackName.text = trackNameString
        }
        if let artistNameString = artistNameString {
            self.artistName.text = artistNameString
        }
        if let albumUImageURL = albumUImageURL {
            self.albumImage.image = UIImage(named: "EmptyImage")
            let queue = OperationQueue()
            queue.addOperation {() -> Void in
                do {
                    /* block for fetch photo */
                    let url = URL(string: "\(albumUImageURL)")!
                    let data = try Data(contentsOf: url)
                    let img = UIImage(data: data)
                    /* */
                    
                    // display in cell when has it image
                    OperationQueue.main.addOperation({ () -> Void in
                        
                        self.albumImage.image = img
                    })
                } catch {
                    return
                }
            }
        }
    }

    
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
