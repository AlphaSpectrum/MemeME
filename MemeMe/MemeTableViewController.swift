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
    let reuseIdentifier = "MemeTableView"
    var memes: [Meme]!
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        memes = appDelegate.memes
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        let meme = self.memes[(indexPath as NSIndexPath).row]
        cell?.textLabel?.text = meme.topText
        cell?.imageView?.image = meme.memedImage
        cell?.detailTextLabel?.text = meme.bottomText
        
        return cell!
    }
}
