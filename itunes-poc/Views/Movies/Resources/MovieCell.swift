//
//  MusicTableViewCell.swift
//  itunes-poc
//
//  Created by David Duarte on 20/08/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    
    @IBOutlet private weak var movieName: UILabel!
    @IBOutlet private weak var longDescription: UILabel!
    @IBOutlet private weak var movieImage: UIImageView!
    
    var movieNameString : String?
    var artistNameString: String?
    var albumUImageURL: URL?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let screenSize = UIScreen.main.bounds
        let separatorHeight = CGFloat(0.25)
        let additionalSeparator = UIView.init(frame: CGRect(x: 10, y: self.frame.size.height-separatorHeight, width: screenSize.width - 20, height: separatorHeight))
        additionalSeparator.backgroundColor = UIColor.lightGray
        self.addSubview(additionalSeparator)
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        if let movieNameString = movieNameString {
            self.movieName.text = movieNameString
        }
        if let artistNameString = artistNameString {
            self.longDescription.text = artistNameString
        }
        if let albumUImageURL = albumUImageURL {
            self.movieImage.image = UIImage(named: "EmptyImage")
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
                        
                        self.movieImage.image = img
                    })
                } catch {
                    return
                }
            }
        }
    }
}
