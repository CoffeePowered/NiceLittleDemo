//
//  VideoCellTableViewCell.swift
//  NiceLittleDemo
//
//  Created by user on 8/29/17.
//  Copyright © 2017 SomeCompany. All rights reserved.
//

import UIKit

class VideoCellTableViewCell: UITableViewCell {

    @IBOutlet weak var innerView: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgThumbnail: UIImageView!
    
    @IBOutlet weak var lblDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        innerView.layer.cornerRadius = 10.0
        innerView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(withVideoItem video: VideoItem) {
        lblTitle.text = video.title
        lblDuration.text = "Duration: " + String(describing: video.duration) + "secs"
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

    }

}
