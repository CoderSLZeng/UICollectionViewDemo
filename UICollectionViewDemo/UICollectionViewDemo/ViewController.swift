//
//  ViewController.swift
//  UICollectionViewDemo
//
//  Created by Anthony on 17/2/21.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 背景颜色
        view.backgroundColor = UIColor.whiteColor()
        
        // 导航条右边按钮
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "下一页", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ViewController.nextPageClick))
    }

    /**
     监听导航条右边按钮点击
     */
    func nextPageClick() {
        
        self.navigationController?.pushViewController(NextPageViewController(), animated: true)
    }


}

