//
//  ViewController.swift
//  UICollectionViewDemo
//
//  Created by Anthony on 17/2/21.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //==========================================================================================================
    // MARK: - 自定义属性
    //==========================================================================================================

    /// cell的标识符
    let cellIdentifier = "Cell"
    
    //==========================================================================================================
    // MARK: - 系统初始化方法
    //==========================================================================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 导航条右边按钮
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "下一页", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ViewController.nextPageClick))
        
        // 布局
        let layout = UICollectionViewFlowLayout()
        
        
        // collectionView
        let collection = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collection.backgroundColor = UIColor.whiteColor()
        collection.dataSource = self
        collection.contentInset = UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0)
        
        // 注册Cell
        collection.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        view.addSubview(collection)
        
    }

    
    //==========================================================================================================
    // MARK: - 处理监听事件
    //==========================================================================================================

    /**
     监听导航条右边按钮点击
     */
    func nextPageClick() {
        
        self.navigationController?.pushViewController(NextPageViewController(), animated: true)
    }

}

//==========================================================================================================
// MARK: - UICollectionViewDataSource
//==========================================================================================================

extension ViewController: UICollectionViewDataSource
{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath)
        cell.backgroundColor = UIColor.redColor()
        return cell
    }
}