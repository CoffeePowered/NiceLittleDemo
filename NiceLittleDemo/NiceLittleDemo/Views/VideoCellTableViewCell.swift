//
//  VideoCellTableViewCell.swift
//  NiceLittleDemo
//
//  Created by user on 8/29/17.
//  Copyright © 2017 SomeCompany. All rights reserved.
//

import UIKit
import AVFoundation
import SDWebImage

/**
    LikeableOrDislikeable: This protocol allows a cell to notify its' delegate
                           that the user has tapped on like (or dislike).
*/
protocol LikeableOrDislikeable {
    
    func didTapLike(onCell cell: VideoCellTableViewCell)
    func didTapDislike(onCell cell: VideoCellTableViewCell)
}

class VideoCellTableViewCell: UITableViewCell {

    var delegate : LikeableOrDislikeable?
    var item : VideoItem?
    
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgThumbnail: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnDislike: UIButton!
    
    var player:AVPlayer?
    var playerItem: AVPlayerItem?
    var playerLayer: AVPlayerLayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        innerView.layer.cornerRadius = 10.0
        innerView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(withVideoItem video: VideoItem,
                   delegate: LikeableOrDislikeable,
                   likeEnabled: Bool,
                   dislikeEnabled: Bool) {
        
        item = video
        self.delegate = delegate
        lblTitle.text = video.title
        if let duration = video.duration {
            lblDuration.text = "Duration: " + String(describing: duration) + "s"
        }
        
        like(highlighted: likeEnabled)
        dislike(highlighted: dislikeEnabled)
        if let timestamp = video.dateTimestamp {
            let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let strDate = dateFormatter.string(from: date)
            lblDate.text = "Date: " + strDate
        } else {
            lblDate.text = "Date: N/A"
        }
        lblDescription.text = video.body
        if let thumbUrlStr = video.thumbnailURL {
             imgThumbnail.sd_setImage(with: URL(string: thumbUrlStr), completed: nil)
        }
        
        // Video player setup:
        if let urlString = video.playbackURL {
            let url = URL(string: urlString)
            let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
            player = AVPlayer(playerItem: playerItem)
            
            playerLayer = AVPlayerLayer(player: player!)
            if let playerLayer = playerLayer,
                let player = player {
                // Note for reviewers: 'let player' is an in-scope non-optional
                playerLayer.isHidden = true
                playerLayer.frame = CGRect(x:0, y: -40, width:videoView.frame.size.width, height:videoView.frame.size.height)
                player.isMuted = true
                self.videoView.layer.addSublayer(playerLayer)
                player.play()
                // infinite loop
                player.actionAtItemEnd = .none
                NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem, queue: nil) { notification in
                    self.player?.seek(to: kCMTimeZero)
                    self.player?.play()
                }
                imgThumbnail.alpha = player.status == AVPlayerStatus.readyToPlay ? 0 : 1
                player.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
            }

        }
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            if player?.status == AVPlayerStatus.readyToPlay {
                let twoSecondsFromNow = DispatchTime.now() + 3
                DispatchQueue.main.asyncAfter(deadline: twoSecondsFromNow) {
                    self.playerLayer?.isHidden = false
                    self.imgThumbnail.isHidden = true
                }
            } else {
                playerLayer?.isHidden = true
                imgThumbnail.isHidden = false
            }
        }
    }
    
    @IBAction func didTapLike(_ sender: Any) {
        delegate?.didTapLike(onCell: self)
    }
    
    @IBAction func didTapDislike(_ sender: Any) {
        delegate?.didTapDislike(onCell: self)
    }
    
    func like(highlighted: Bool) {
        btnLike.alpha = highlighted ? 1 : 0.3
    }
    
    func dislike(highlighted: Bool) {
        btnDislike.alpha = highlighted ? 1 : 0.3
    }
    
}
