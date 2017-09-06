//
//  VideosTableViewController.swift
//  NiceLittleDemo
//
//  Created by user on 8/29/17.
//  Copyright © 2017 SomeCompany. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class VideosTableViewController: UIViewController {

    public var service: Service?
    @IBOutlet weak var tableView: UITableView!
    
    var videos : [VideoItem] = []
    var likeState : [Bool] = []
    var dislikeState: [Bool] = []

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
                    self.initLikeStates()
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
    
    fileprivate func initLikeStates() {
        self.dislikeState = []
        self.likeState = []
        for _ in videos {
            self.likeState.append(false)
            self.dislikeState.append(false)
        }
    }
    
    func serviceError() {
        let alert = UIAlertController(title: "Error", message: "An error occurred while trying to connect to the server. Have you tried turning it off and on again?", preferredStyle: .alert)
        let accept = UIAlertAction(title: "It is what it is", style: .default, handler: nil)
        alert.addAction(accept)
        self.present(alert, animated: true, completion: nil)
    }
}

extension VideosTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = videos[indexPath.row]
            let videoURL = URL(string: item.playbackURL!)
            let player = AVPlayer(url: videoURL!)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
    }
}

extension VideosTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell") as! VideoCellTableViewCell
        cell.configure(withVideoItem: videos[indexPath.row],
                       delegate: self,
                       likeEnabled: likeState[indexPath.row],
                       dislikeEnabled: dislikeState[indexPath.row])
        return cell
    }
}

extension VideosTableViewController: LikeableOrDislikeable {
    
    func didTapLike(onCell cell: VideoCellTableViewCell) {
        if let item = cell.item {
            if let index = videos.index(of: item) {
                likeState[index] = !likeState[index]
                cell.like(highlighted: likeState[index])
                if likeState[index] && dislikeState[index] {
                    dislikeState[index] = false
                    cell.dislike(highlighted: false)
                }
            }
        }
    }
    
    func didTapDislike(onCell cell: VideoCellTableViewCell) {
        if let item = cell.item {
            if let index = videos.index(of: item) {
                dislikeState[index] = !dislikeState[index]
                cell.dislike(highlighted: dislikeState[index])
                if dislikeState[index] && likeState[index] {
                    likeState[index] = false
                    cell.like(highlighted: false)
                }
            }
        }
    }
}
