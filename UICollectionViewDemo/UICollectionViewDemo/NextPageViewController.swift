//
//  NextPageViewController.swift
//  UICollectionViewDemo
//
//  Created by Anthony on 17/2/21.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit

class NextPageViewController: UIViewController {
    
    //==========================================================================================================
    // MARK: - 自定义属性
    //==========================================================================================================

    /// cell的标识符
    let cellIdentifier = "Cell"
    
    //==========================================================================================================
    // MARK: - 懒加载
    //==========================================================================================================

    /// 布局
    lazy var layout: UICollectionViewLayout = {
        () -> UICollectionViewLayout
        in
        let layout = CircularLayout()
        return layout
    }()
    
    /// collection
    lazy var collection: UICollectionView = {
        () -> UICollectionView
        in
        let collection = UICollectionView(frame: CGRectZero, collectionViewLayout: self.layout)
        collection.backgroundColor = UIColor.whiteColor()
        collection.center = self.view.center
        collection.bounds = self.view.bounds
        
        collection.dataSource = self
        
        let nib = UINib(nibName: "\(CustomCell.self)", bundle: nil)
        collection.registerNib(nib, forCellWithReuseIdentifier: self.cellIdentifier)
        

        return collection
    }()
    
    lazy var itemsList: [CellItem] = {
        () -> [CellItem]
        in
        
        return CellItem.itemList()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 添加collection
        view.addSubview(collection)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "切换布局", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.changeLayout))
        
        // 添加手势
        let tapRecognize = UITapGestureRecognizer(target: self, action: "hadleTap:")
        collection.addGestureRecognizer(tapRecognize)
        
    }
    
    //==========================================================================================================
    // MARK: - 处理监听事件
    //==========================================================================================================
    func changeLayout() {
        
        if layout is CircularLayout {
            layout = UICollectionViewFlowLayout()
            let flowLayout = (layout as! UICollectionViewFlowLayout)
//            flowLayout.scrollDirection = UICollectionViewScrollDirection.Vertical
            flowLayout.itemSize = CGSize(width: 60, height: 90)
        } else {
            layout = CircularLayout()
        }
        
        self.collection.setCollectionViewLayout(layout, animated: true)
    }
    
    func hadleTap(sender: UITapGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Ended {
            let tapPoint = sender.locationInView(self.collection)
            
            if let indexPath = self.collection.indexPathForItemAtPoint(tapPoint)
            {
                
                print("删除点击的cell")
                //
                /**
                 *  这个方法可以用来对collectionView中的元素进行批量的插入，删除，移动等操作，同时将触发collectionView所对应的layout的对应的动画
                 *  相应的动画由layout中的下列四个方法来定义：
                 *  initialLayoutAttributesForAppearingItemAtIndexPath:
                 *  initialLayoutAttributesForAppearingDecorationElementOfKind:atIndexPath:
                 *  finalLayoutAttributesForDisappearingItemAtIndexPath:
                 *  finalLayoutAttributesForDisappearingDecorationElementOfKind:atIndexPath:
                 */
                self.collection.performBatchUpdates({
                    self.collection.deleteItemsAtIndexPaths([indexPath])
                    self.itemsList.removeAtIndex(indexPath.item)
                    }, completion: nil)
            } else
            {
                print("添加随机的cell")
                
                // 随机数
                let val = arc4random_uniform(UInt32(self.itemsList.count))
                // 添加模型数据
                let item = self.itemsList[Int(val)]
                self.itemsList.append(item)
                // 插入cell
                self.collection.insertItemsAtIndexPaths([NSIndexPath(forItem: Int(val) , inSection: 0)])
                
                // 做动画
                dispatch_async(dispatch_get_global_queue(0, 0), { 
                    let val = arc4random_uniform(UInt32(self.itemsList.count))
                    let item = self.itemsList[Int(val)]
                    self.itemsList.append(item)
                    dispatch_async(dispatch_get_main_queue(), { 
                        self.collection.reloadData() // 刷新数据
                    })
                })
                
                
            }
            
            
        }
    }

}

//==========================================================================================================
// MARK: - UICollectionViewDataSource
//==========================================================================================================

extension NextPageViewController: UICollectionViewDataSource
{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemsList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collection.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! CustomCell
        
        let item = self.itemsList[indexPath.item]
        
        cell.image = item.image
        cell.text = item.name
        
        cell.layer.cornerRadius = 30
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.blackColor().CGColor
        
        return cell
        
    }
    
}