//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Alan Campos on 6/12/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let reuseIdentifier = "MemeTableViewCell"
    var memes: [Meme]!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        memes = appDelegate.memes
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)!
        let meme = memes[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = meme.topText
        cell.imageView?.image = meme.memedImage
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "SentMemeDetailsViewController") as! SentMemeDetailsViewController
        
        detailsViewController.receivedImage = self.memes[(indexPath as NSIndexPath).row].memedImage
        self.navigationController!.pushViewController(detailsViewController, animated: true)
    }
}
