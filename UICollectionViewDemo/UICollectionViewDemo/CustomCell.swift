//
//  CustomCell.swift
//  UICollectionViewDemo
//
//  Created by Anthony on 17/2/21.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit

class CustomCell: UICollectionViewCell {
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    
    var image: UIImage? {
        didSet {
            guard let image = image else {
                return
            }
            
            contentImageView.image = image
        }
    }
    
    var text: String? {
        didSet {
            guard let text = text else {
                return
            }
            
            contentLabel.text = text
        }
    }
}
