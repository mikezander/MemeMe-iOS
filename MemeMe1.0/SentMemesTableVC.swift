//
//  SentMemesTableVC.swift
//  MemeMe1.0
//
//  Created by Michael Alexander on 5/23/17.
//  Copyright © 2017 Michael Alexander. All rights reserved.
//

import Foundation
import UIKit

class SentMemesTableVC: UITableViewController{

    var memes = [Meme]()
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        tableView.reloadData()
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let meme = memes[indexPath.row]
       
       
        cell.topTextLabel = setMemeLabel(cell.topTextLabel, text: meme.topText)
        cell.bottomTextLabel = setMemeLabel(cell.bottomTextLabel, text: meme.bottomText)
        cell.memeImageView?.image = meme.originalImage
        
        cell.memeLabel?.text = "\(meme.topText)...\(meme.bottomText)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let memeDetailVC = storyboard?.instantiateViewController(withIdentifier: "MemeDetailVC") as! MemeDetailVC
        memeDetailVC.meme = memes[indexPath.row]
        navigationController!.pushViewController(memeDetailVC, animated: true)
        
    }
    
    //reformatting text for thumbnail in table view
    func setMemeLabel(_ label: UILabel, text: String) -> UILabel{
        let myString = NSMutableAttributedString(string: text, attributes:
            [NSStrokeColorAttributeName: UIColor.black,
             NSForegroundColorAttributeName: UIColor.white,
             NSFontAttributeName: UIFont(name: "Impact", size: 12)!,
             NSStrokeWidthAttributeName: -3.0])
    
    // set label Attribute
    label.attributedText = myString
        return label
    }
}
