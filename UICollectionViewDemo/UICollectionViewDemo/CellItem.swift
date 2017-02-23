//
//  CellItem.swift
//  UICollectionViewDemo
//
//  Created by Anthony on 17/2/22.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit

class CellItem: NSObject {
    
    //==========================================================================================================
    // MARK: - 属性
    //==========================================================================================================
    var name: String?
    var icon: String?
    
    
    
    var image: UIImage? {
        get {
            guard let iconStr = self.icon else
            {
                return UIImage(named: "")
            }
            
            
            return UIImage(named: iconStr)
        }
    
    }
    //==========================================================================================================
    // MARK: - 自定义构造函数
    //==========================================================================================================
    /**
     使用字典实例化模型
     
     - parameter dict: 字典数据
     
     - returns: 对象
     */
    init(dict: [String: AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) { }
    
    /**
     类方法可以快速实例化一个类
     
     - parameter dict: 字典
     
     - returns: 类
     */
    class func item(dict: [String: AnyObject]) -> CellItem
    {
        return CellItem(dict: dict)
    }
    
    /**
     获取模型数组
     */
    class func itemList() -> [CellItem]
    {
        guard let pathFile = NSBundle.mainBundle().pathForResource("icons", ofType: "plist") else
        {
            print("plist文件不存在")
            return []
        }
        
        guard let array = NSArray(contentsOfFile: pathFile) else
        {
            return []
        }
        
        var arrayM = [CellItem]()
        
        for dict in array {
            let cellItem = CellItem.item(dict as! [String : AnyObject])
            arrayM.append(cellItem)
        }
        
        return arrayM
        
    }

}
