//
//  PhotoThumbnail.swift
//  Google Keep
//
//  Created by Jamie Alaniz on 11/16/17.
//  Copyright © 2017 David Liang. All rights reserved.
//

import UIKit

class PhotoThumbnail: UICollectionViewCell {
    

    @IBOutlet var imgView: UIImageView!
    
    
    
    func setThumbnailImage(_ thumbnailImage: UIImage){
        self.imgView.image = thumbnailImage
    }
    
}

