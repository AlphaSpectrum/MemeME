//
//  Meme.swift
//  MemeMe
//
//  Created by Alan Campos on 5/9/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    var topText: UITextField!
    var bottomText: UITextField!
    var image: UIImageView!
    var textAttributes: [String: Any]!
    var imageDimensions: CGRect!
    
    func getMemedImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(imageDimensions.size, false, 0.0)
        
        image?.image?.draw(in: imageDimensions)
        image?.contentMode = .scaleAspectFill
        
        // Assign the position for top text
        let top = CGRect(x: (imageDimensions.width/2) - (topText.frame.width/2), y: 0, width: imageDimensions.width, height: imageDimensions.height)
        
        // Assign the position for bottom text
        let bottom = CGRect(x: (imageDimensions.width/2) - (bottomText.frame.width/2), y: (imageDimensions.height - bottomText.frame.height), width: imageDimensions.width, height: imageDimensions.height)
        
        (topText.text! as NSString).draw(in: top, withAttributes: textAttributes)
        (bottomText.text! as NSString).draw(in: bottom, withAttributes: textAttributes)
        
        let memedImage: UIImage  = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        return memedImage
    }
}
