//
//  HomeTableViewCell.swift
//  Warble
//
//  Created by Satyam Jaiswal on 2/27/17.
//  Copyright © 2017 Satyam Jaiswal. All rights reserved.
//

import UIKit

protocol CellDelegate {
    func onTapCellLike(_ sender: AnyObject?)
    func onTapCellRetweet(_ sender: AnyObject?)
    func onTapCellProfileImage(_ sender: AnyObject?)
    func onTapCellReply(_ sender: AnyObject?)
}

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
    @IBOutlet weak var mediaImageView: UIImageView!
    
    var delegate: CellDelegate?
    
    var tweet:Tweet?{
        didSet{
            if let profileImageUrl = tweet?.user?.profileImageUrl{
                self.profileImageView.setImageWith(profileImageUrl)
                self.profileImageView.layer.cornerRadius = 5
                self.profileImageView.layer.masksToBounds = true
            }
            
            if let name = tweet?.user?.name{
                self.nameLabel.text = name
            }
            
            if let handle = tweet?.user?.handle{
                self.handleLabel.text = "@\(handle)"
            }
            
            if let tweetText = tweet?.text{
                self.tweetLabel.text = tweetText
            }
            
            if let timestamp = tweet?.timestamp{
                self.timestampLabel.text = Date().offsetFrom(timestamp)
            }
            
            if let retweetCount = tweet?.retweetCount{
                if retweetCount > 0{
                    retweetCountLabel.isHidden = false
                    self.retweetCountLabel.text = "\(retweetCount)"
                }else{
                    retweetCountLabel.isHidden = true
                }
                
            }
            
            if let favoriteCount = tweet?.favoriteCount{
                
                if favoriteCount > 0{
                    self.favoriteCountLabel.isHidden = false
                    self.favoriteCountLabel.text = "\(favoriteCount)"
                }else{
                    self.favoriteCountLabel.isHidden = true
                }
            }
            
            if let favorited = tweet?.favorited{
                if favorited{
                    self.favoriteImageView.image = UIImage(named: "favor-icon-red")
                }else{
                    self.favoriteImageView.image = UIImage(named: "favor-icon-gray")
                }
            }
            
            if let retweeted = tweet?.retweeted{
                if retweeted{
                    self.retweetImageView.image = UIImage(named: "retweet-icon-green")
                }else{
                    self.retweetImageView.image = UIImage(named: "retweet-icon")
                }
            }
            
            if let retweetedUser = tweet?.retweetedBy{
                self.retweetedLabel.text = "\(retweetedUser.name!) retweeted"
                self.retweetedLabel.isHidden = false
                self.retweetedImageView.isHidden = false
            }else{
                self.retweetedLabel.isHidden = true
                self.retweetedImageView.isHidden = true
            }
            
            if let mediaUrl = tweet?.imageUrl{
//                print("media available")
                self.mediaImageView.isHidden = false
                self.mediaImageView.setImageWith(mediaUrl)
                self.mediaImageView.layer.cornerRadius = 5
                self.mediaImageView.layer.masksToBounds = true
            }else{
//                print("media unavailable")
                self.mediaImageView.isHidden = true
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureGestureRecognizers()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureGestureRecognizers(){
        let tapRetweet = UITapGestureRecognizer(target: self, action: #selector(tappedRetweet(_:)))
        self.retweetImageView.addGestureRecognizer(tapRetweet)
        self.retweetImageView.isUserInteractionEnabled = true
        
        let tapLike = UITapGestureRecognizer(target: self, action: #selector(tappedLike(_:)))
        self.favoriteImageView.addGestureRecognizer(tapLike)
        self.favoriteImageView.isUserInteractionEnabled = true
        
        let tapProfileImage = UITapGestureRecognizer(target: self, action: #selector(onTappedProfileImage))
        self.profileImageView.addGestureRecognizer(tapProfileImage)
        self.profileImageView.isUserInteractionEnabled = true
        
        let tapReply = UITapGestureRecognizer(target: self, action: #selector(onTappedReply))
        self.replyImageView.addGestureRecognizer(tapReply)
        self.replyImageView.isUserInteractionEnabled = true
    }
    
    func tappedRetweet(_ sender: AnyObject){
        delegate?.onTapCellRetweet(sender)
    }
    
    func tappedLike(_ sender: AnyObject){
        delegate?.onTapCellLike(sender)
        
    }
    
    func onTappedProfileImage(_ sender: AnyObject){
        delegate?.onTapCellProfileImage(sender)
    }
    
    func onTappedReply(_ sender: AnyObject){
        delegate?.onTapCellReply(sender)
    }
}

extension Date {
    func yearsFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.year, from: date, to: self, options: []).year!
    }
    func monthsFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.month, from: date, to: self, options: []).month!
    }
    func weeksFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.weekOfYear, from: date, to: self, options: []).weekOfYear!
    }
    func daysFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.day, from: date, to: self, options: []).day!
    }
    func hoursFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.hour, from: date, to: self, options: []).hour!
    }
    func minutesFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.minute, from: date, to: self, options: []).minute!
    }
    func secondsFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.second, from: date, to: self, options: []).second!
    }
    func offsetFrom(_ date:Date) -> String {
        
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
        if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        return ""
    }
}
