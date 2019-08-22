//
//  TvShowCell.swift
//  itunes-poc
//
//  Created by David Duarte on 22/08/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import UIKit

class TvShowCell: UITableViewCell {
    
    @IBOutlet private weak var showImage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    var dateString : String?
    var titleString: String?
    var showUImageURL: URL?
    
    override func awakeFromNib() {
        let screenSize = UIScreen.main.bounds
        let separatorHeight = CGFloat(0.25)
        let additionalSeparator = UIView.init(frame: CGRect(x: 10, y: self.frame.size.height-separatorHeight, width: screenSize.width - 20, height: separatorHeight))
        additionalSeparator.backgroundColor = UIColor.lightGray
        self.addSubview(additionalSeparator)
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        if let dateString = dateString {
            self.dateLabel.text = dateString
        }
        if let titleString = titleString {
            self.titleLabel.text = titleString
        }
        if let showUImageURL = showUImageURL {
            self.showImage.image = UIImage(named: "EmptyImage")
            let queue = OperationQueue()
            queue.addOperation {() -> Void in
                do {
                    /* block for fetch photo */
                    let url = URL(string: "\(showUImageURL)")!
                    let data = try Data(contentsOf: url)
                    let img = UIImage(data: data)
                    /* */
                    
                    // display in cell when has it image
                    OperationQueue.main.addOperation({ () -> Void in
                        
                        self.showImage.image = img
                    })
                } catch {
                    return
                }
            }
        }
    }
}
