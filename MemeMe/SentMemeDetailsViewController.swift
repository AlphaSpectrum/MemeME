//
//  SentMemeDetailsViewController.swift
//  MemeMe
//
//  Created by Alan Campos on 6/23/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import UIKit

class SentMemeDetailsViewController: UIViewController {
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    var receivedImage: UIImage!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
    }
        
    override func viewDidLoad() {
        memeImageView.image = receivedImage
        memeImageView.contentMode = .scaleAspectFit
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
}
