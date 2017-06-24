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
        memeImageView.image = receivedImage
        memeImageView.contentMode = .scaleAspectFit
    }
}