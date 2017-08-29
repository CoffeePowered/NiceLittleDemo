//
//  ViewController.swift
//  NiceLittleDemo
//
//  Created by Lucas V on 8/29/17.
//  Copyright © 2017 SomeCompany. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    let service = Service()
    
    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTapLogin(_ sender: Any) {
        if let usr = txtUser.text,
            let pwd = txtPassword.text {
            service.logIn(withUser: usr, andPassword: pwd, completion: {(success) in
                if success {
                    self.loginSucceeded()
                } else {
                    self.loginFailed()
                }
            })
        }
    }
    
    func loginFailed() {
        presentAlert(withTitle: "Login Failed", andMessage: "The user name or password you entered is not correct")
    }
    
    func loginSucceeded() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let videosVC = storyboard.instantiateViewController(withIdentifier: "VideosTableViewController") as? VideosTableViewController {
            videosVC.service = service
            self.navigationController?.present(videosVC, animated: true, completion: nil)
        } else {
            presentAlert(withTitle: "Error", andMessage: "Whoops, something went awfully wrong")
        }
    }
    
    func presentAlert(withTitle title: String, andMessage message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }

    

}

