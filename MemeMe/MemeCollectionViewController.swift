//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Alan Campos on 6/12/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var reuseIdentifier = "MemeCollectionViewCell"
    var memes: [Meme]!
    
    override func viewWillAppear(_ animated: Bool) {
        memes = appDelegate.memes
    }
  
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCollectionViewCell
        let meme = memes[(indexPath as NSIndexPath).row]
        cell.memeImageView.image = meme.memedImage
        return cell
    }
}
