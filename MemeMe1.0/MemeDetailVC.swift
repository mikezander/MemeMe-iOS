//
//  MemeDetailVC.swift
//  MemeMe1.0
//
//  Created by Michael Alexander on 5/27/17.
//  Copyright © 2017 Michael Alexander. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailVC: UIViewController{

    var meme: Meme!

    @IBOutlet weak var detailMeme: UIImageView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
         
        tabBarController?.tabBar.isHidden = true
       
        detailMeme.image = meme.memedImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        tabBarController?.tabBar.isHidden = false
    }

    
   
}
