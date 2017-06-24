//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Alan Campos on 6/12/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var reuseIdentifier = "MemeCollectionViewCell"
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space:CGFloat = 3.0
        let dimensionW = (view.frame.size.width - (2 * space)) / 3.0
        let dimensionH = (view.frame.size.height - (2 * space)) / 3.0

        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimensionW, height: dimensionH)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        memes = appDelegate.memes
        self.collectionView?.reloadData()
    }
  
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCollectionViewCell
        let meme = memes[(indexPath as NSIndexPath).row]
        cell.memeImageView.image = meme.memedImage
        cell.memeImageView.contentMode = .scaleAspectFit
        return cell
    }
}
