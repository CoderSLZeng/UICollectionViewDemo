//
//  CircularLayout.swift
//  UICollectionViewDemo
//
//  Created by Anthony on 17/2/22.
//  Copyright © 2017年 SLZeng. All rights reserved.
//  // 圆形布局

import UIKit

class CircularLayout: UICollectionViewLayout {
    
    //==========================================================================================================
    // MARK: - 自定义基本属性
    //==========================================================================================================

    private let ITEM_SIZE: CGFloat = 70.0
    private var insertIndexPaths = [NSIndexPath]()
    
    private var _cellCount: Int?
    private var _collectionSize: CGSize?
    private var _center: CGPoint?
    private var _radius: CGFloat?
    
    //==========================================================================================================
    // MARK: - 重写系统初始化函数
    //==========================================================================================================

    /**
     首先被调用，一般在该方法中设定一些必要的layout的结构和初始需要的参数等
     */
    override func prepareLayout() {
        super.prepareLayout()
        
        guard let frameSize = self.collectionView?.frame.size else
        {
            return
        }
        
        _cellCount = self.collectionView?.numberOfItemsInSection(0)
        _center = CGPoint(x: frameSize.width * 0.5, y: frameSize.height * 0.5)
        _radius = min(frameSize.width, frameSize.height) * 0.4
        _collectionSize = frameSize
    }
    
    /**
     返回collectionView的内容区域的总大小 （不是可见区域）
     */
    override func collectionViewContentSize() -> CGSize {
        guard let size = _collectionSize else
        {
            return CGSizeZero
        }
        
        return size
    }
    
    /**
     返回rect中的所有的元素的布局属性
     */
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attrsM = [UICollectionViewLayoutAttributes]()
        if let count = self._cellCount {
            for i in 0..<count {
                let indexPath = NSIndexPath(forItem: i, inSection: 0)
                guard let attrs = self.layoutAttributesForItemAtIndexPath(indexPath) else
                {
                    return []
                }
                
                attrsM.append(attrs)
            }
        }
        
        return attrsM
    }
    
    
    /**
     返回对应于indexPath的位置的cell的布局属性
     */
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attrs = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        attrs.size = CGSize(width: ITEM_SIZE, height: ITEM_SIZE)
        guard let center = _center else
        {
            return nil
        }
        
        guard let radius = _radius else
        {
            return nil
        }
        
        guard let cellCount = _cellCount else
        {
            return nil
        }
        
        let x = Double(center.x) + Double(radius) * cos(Double(2 * indexPath.item) * M_PI / Double(cellCount))
        let y = Double(center.y) + Double(radius) * sin(Double(2 * indexPath.item) * M_PI / Double(cellCount))
        attrs.center = CGPoint(x: CGFloat(x), y: CGFloat(y))
        
        return attrs
    }
    /**
     首先会调用prepareForCollectionViewUpdates，我们在这里拿到那个新增的NSIndexPath ，然后在这个方法中设置一些初始位置
     */
    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        var attributes = super.initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath)
        
        if self.insertIndexPaths.contains(itemIndexPath) {
            
            if let _ = attributes{
                attributes = self.layoutAttributesForItemAtIndexPath(itemIndexPath)
            }
            
            // Configure attributes ...
            attributes!.alpha = 0.0;
            attributes!.center =  CGPointMake(_center!.x, _center!.y);
        }
        
        return attributes;
       
    }
    
    override func prepareForCollectionViewUpdates(updateItems: [UICollectionViewUpdateItem]) {
        super.prepareForCollectionViewUpdates(updateItems)
        self.insertIndexPaths = [NSIndexPath]()
        
        for update in updateItems {
            if update.updateAction == UICollectionUpdateAction.Insert {
                self.insertIndexPaths.append(update.indexPathAfterUpdate!)
            }
        }
    }
}

