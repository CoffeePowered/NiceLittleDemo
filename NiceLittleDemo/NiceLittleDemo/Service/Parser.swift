//
//  Parser.swift
//  NiceLittleDemo
//
//  Created by Lucas V on 8/29/17.
//  Copyright © 2017 SomeCompany. All rights reserved.
//

import Foundation
import Alamofire

/**
    Parser: This class is responsible for translating the JSON from service to objects.
            It is also responsible for making corrections to URLs and such.
*/

class Parser {
    static func doYaThing(withDictionary json: [String:Any],
                          usingThumbnailBaseURL thumbnailBaseURL: String,
                          andVideosBaseURL videosBaseURL: String) ->[VideoItem] {
        var result : [VideoItem] = []
        if let videosArray = json["videos"] as? [Any] {
            for videoElement in videosArray {
                if let videoDict = videoElement as? [String:Any] {
                    if let videoID = videoDict["id"] as? Int,
                       let title = videoDict["title"] as? String,
                       let timestamp = videoDict["date"] as? Int,
                       let duration = videoDict["duration"] as? Int,
                       let playbackURL = videoDict["playback_url"] as? String,
                       let thumbnail = videoDict["thumb"] as? String,
                       let landingURL = videoDict["url"] as? String,
                       let body = videoDict["body"] as? String{
                        var tags: [VideoTag] = []
                        if let tagsDicts = videoDict["tags"] as? [Any]{
                            for tagElement in tagsDicts {
                                if let tagDict = tagElement as? [String:Any] {
                                    if let tagID = tagDict["id"] as? String,
                                       let tagType = tagDict["type"] as? String,
                                       let tagTitle = tagDict["title"] as? String {
                                       let tag = VideoTag(tagID: tagID, type: tagType, title: tagTitle)
                                        tags.append(tag)
                                    }
                                }
                            }
                        }
                        let correctThumbURL = thumbnailBaseURL + Parser.applyCorrection(to: thumbnail)
                        let videoItem = VideoItem(videoID: videoID, title: title, dateTimestamp: timestamp, duration: duration, playbackURL: videosBaseURL + playbackURL, thumbnailURL: correctThumbURL, body: body, landingURL: landingURL, tags: tags)
                        result.append(videoItem)
                    }
                }
            }
        }
        return result
    }
    
    static func applyCorrection(to stringURL: String) -> String {
        let result = stringURL.replacingOccurrences(of: "//", with: "/")
        return result
    }
}
