//
//  SentMemesCollectionVC.swift
//  MemeMe1.0
//
//  Created by Michael Alexander on 5/23/17.
//  Copyright © 2017 Michael Alexander. All rights reserved.
// *story board size inspector was 320 x 568 changer to 384 x 512 to confrom to runtime error*

import Foundation
import UIKit

class SentMemesCollectionVC: UICollectionViewController{

    var memes = [Meme]()
    

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
       // title = "Sent Memes"
        adjustFlowLayout(size: view.frame.size)        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        
        collectionView?.reloadData()
    }
        
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return memes.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let meme = memes[indexPath.row]
        
        cell.topTextLabel = setMemeLabel(cell.topTextLabel, text: meme.topText)
        cell.bottomTextLabel = setMemeLabel(cell.bottomTextLabel, text: meme.bottomText)
        // Set the memed image cell
        cell.memedImageView?.image = meme.originalImage
         
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let memeDetailVC = storyboard?.instantiateViewController(withIdentifier: "MemeDetailVC") as! MemeDetailVC
        memeDetailVC.meme = memes[indexPath.row]
        navigationController!.pushViewController(memeDetailVC, animated: true)
        
    }
    
    func adjustFlowLayout(size: CGSize) {
        let space: CGFloat = 2.0
        let dimension:CGFloat = size.width >= size.height ? (size.width - (5 * space)) / 6.0 :  (size.width - (2 * space)) / 3.0
        flowLayout.minimumLineSpacing = 1.0
        flowLayout.minimumInteritemSpacing = 2.0
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
    }
    
     //reformatting text for thumbnail in collection view
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
