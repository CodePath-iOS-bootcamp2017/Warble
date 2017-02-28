//
//  HomeTableViewCell.swift
//  Warble
//
//  Created by Satyam Jaiswal on 2/27/17.
//  Copyright © 2017 Satyam Jaiswal. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var replyImageView: UIImageView!
    @IBOutlet weak var retweetedImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var retweetedLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    var tweet:Tweet?{
        didSet{
            if let profileImageUrl = tweet?.user?.profileImageUrl{
                self.profileImageView.setImageWith(profileImageUrl)
            }
            
            if let name = tweet?.user?.name{
                self.nameLabel.text = name
            }
            
            if let handle = tweet?.user?.handle{
                self.handleLabel.text = handle
            }
            
            if let tweetText = tweet?.text{
                self.tweetLabel.text = tweetText
            }
            
            if let timestamp = tweet?.timestamp?.description{
                self.timestampLabel.text = timestamp
            }
            
            if let retweetCount = tweet?.retweetCount{
                self.retweetCountLabel.text = "\(retweetCount)"
            }
            
            if let favoriteCount = tweet?.favoriteCount{
                self.favoriteCountLabel.text = "\(favoriteCount)"
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
