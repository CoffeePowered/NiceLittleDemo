//
//  MovieItem.swift
//  NiceLittleDemo
//
//  Created by Lucas V on 8/29/17.
//  Copyright © 2017 SomeCompany. All rights reserved.
//

import Foundation

struct VideoTag {
    var tagID: String?
    var type: String?
    var title: String?
}

struct VideoItem {
    var videoID : Int?
    var title: String?
    var dateTimestamp: Int?
    var duration: Int?
    var playbackURL: String?
    var thumbnailURL: String?
    var body: String?
    var landingURL: String?
    var tags: [VideoTag] = []
}
