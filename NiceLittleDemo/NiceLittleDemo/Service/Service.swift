//
//  Service.swift
//  NiceLittleDemo
//
//  Created by user on 8/29/17.
//  Copyright © 2017 SomeCompany. All rights reserved.
//

import Foundation
import Alamofire


/**
        Service: This class is responsible for retrieving video items 
                 from the web service, and also for authentication.
 */

class Service {
    
    // MARK: Constants and flags
    fileprivate let sampleUser = "wwe"
    fileprivate let samplePass = "wwe"
    fileprivate var loggedIn = false
    fileprivate let endpointURL = "http://www.wwe.com/feeds/sapphire/videos/all/all/0,20"
    fileprivate let thumbnailBaseURL = "http://www.wwe.com"
    
    // MARK: connection to server
    func fetchMovies(completion: @escaping ([VideoItem]?)->Void) {
        Alamofire.request(endpointURL).responseJSON { response in
            if let json = response.result.value {
                if let responseDict = json as? [String:Any] {
                    completion(Parser.doYaThing(withDictionary: responseDict,
                                                usingThumbnailBaseURL: self.thumbnailBaseURL,
                                                andVideosBaseURL: "http:"))
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
    
    // MARK: Login methods
    func isLoggedIn() -> Bool {
        return loggedIn
    }
    
    func logIn(withUser user: String, andPassword password: String, completion: (Bool)->Void) {
        loggedIn = user == sampleUser && password == samplePass
        completion(loggedIn)
    }
}
