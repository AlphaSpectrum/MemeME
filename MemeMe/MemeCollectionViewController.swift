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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        memes = appDelegate.memes
        self.collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 1.0
       
        let previewDimension = scaleFrameSize(by: 3.0, view: view)
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = previewDimension
    }
    
    func scaleFrameSize(by scaleValue: CGFloat, view: UIView ) -> CGSize {
        let width = (view.frame.size.width - (2 * scaleValue)) / scaleValue
        let height = (view.frame.size.height - (2 * scaleValue)) / scaleValue
        let dimension = CGSize(width: width, height: height)
        return dimension
    }
  
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCollectionViewCell
        let meme = memes[(indexPath as NSIndexPath).row]
        cell.memeImageView.image = meme.memedImage
        cell.memeImageView.contentMode = .scaleAspectFill
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "SentMemeDetailsViewController") as! SentMemeDetailsViewController
        let currentSelectedImage = memes[(indexPath as NSIndexPath).row].memedImage
        detailsViewController.receivedImage = currentSelectedImage
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
}
