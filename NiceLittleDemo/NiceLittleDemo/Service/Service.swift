//
//  Service.swift
//  NiceLittleDemo
//
//  Created by user on 8/29/17.
//  Copyright © 2017 SomeCompany. All rights reserved.
//

import Foundation
import Alamofire

class Service {
    fileprivate let sampleUser = "wwe"
    fileprivate let samplePass = "wwe"
    fileprivate var loggedIn = false
    
    func fetchMovies(completion: ([VideoItem])->Void) {
        Alamofire.request("http://www.wwe.com/feeds/sapphire/videos/all/all/0,20").responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
    }
    
    func isLoggedIn() -> Bool {
        return loggedIn
    }
    
    func logIn(withUser user: String, andPassword password: String, completion: (Bool)->Void) {
        loggedIn = user == sampleUser && password == samplePass
        completion(loggedIn)
    }
}
