//
//  CustomCell.swift
//  UICollectionViewDemo
//
//  Created by Anthony on 17/2/21.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit

class CustomCell: UICollectionViewCell {
    /// 图标视图
    @IBOutlet weak var contentImageView: UIImageView!
    /// 图标名称
    @IBOutlet weak var contentLabel: UILabel!
    
    // 图片
    var image: UIImage? {
        didSet {
            guard let image = image else {
                return
            }
            
            contentImageView.image = image
        }
    }
    
    // 文字
    var text: String? {
        didSet {
            guard let text = text else {
                return
            }
            
            contentLabel.text = text
        }
    }
}
