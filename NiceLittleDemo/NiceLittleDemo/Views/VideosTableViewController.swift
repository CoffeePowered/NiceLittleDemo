//
//  VideosTableViewController.swift
//  NiceLittleDemo
//
//  Created by user on 8/29/17.
//  Copyright © 2017 SomeCompany. All rights reserved.
//

import UIKit

class VideosTableViewController: UIViewController {

    public var service: Service?
    @IBOutlet weak var tableView: UITableView!
    
    var videos : [VideoItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        fetchVideosFromService()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchVideosFromService() {
        tableView.alpha = 0
        if let service = service {
            service.fetchMovies(completion: {result in
                if let videos = result {
                    self.videos = videos
                    self.tableView.reloadData()
                    UIView.animate(withDuration: 1.0, animations: {
                        self.tableView.alpha = 1
                    })
                } else {
                    self.serviceError()
                }
            })
        } else {
            serviceError()
        }
    }
    
    func serviceError() {
        
    }
}

extension VideosTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension VideosTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell") as! VideoCellTableViewCell
        cell.configure(withVideoItem: videos[indexPath.row])
        return cell
    }
}
