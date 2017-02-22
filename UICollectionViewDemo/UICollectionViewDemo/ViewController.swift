//
//  ViewController.swift
//  UICollectionViewDemo
//
//  Created by Anthony on 17/2/21.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit

//struct CellContent {
//    var img: String
//    var name: String
//}

class ViewController: UIViewController {

    //==========================================================================================================
    // MARK: - 自定义属性
    //==========================================================================================================

    /// cell的标识符
    let cellIdentifier = "Cell"
    
    //==========================================================================================================
    // MARK: - 懒加载
    //==========================================================================================================

    /// 存放cell属性的数组
//    lazy var dict: [CellContent] = {
//        ()-> [CellContent]
//        in
//        var dict = [CellContent]()
//        
//        for i in 0...9 {
//            // dict.append(CellContent(img: "icon_0" + String(i), name: "程序" + String(i)))
//            dict.append(CellContent(img: "icon_0\(i)", name: "程序\(i)"))
//        }
//        return dict
//    
//    }()
    
    /// 存放Cell模型数据的数组
    lazy var itemList: [CellItem] = {
        () -> [CellItem]
        in
        return CellItem.itemList()
        
    }()
    
    //==========================================================================================================
    // MARK: - 系统初始化方法
    //==========================================================================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 导航条右边按钮
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "下一页", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ViewController.nextPageClick))
        
        // 布局
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        layout.itemSize = CGSize(width: 80, height: 90)
        layout.minimumLineSpacing = 10.0 // 上下间隔
        layout.minimumInteritemSpacing = 5.0 // 左右间隔
        layout.headerReferenceSize = CGSize(width: 20, height: 20)
        layout.footerReferenceSize = CGSize(width: 20, height: 20)
        
        // collectionView
        let collection = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collection.backgroundColor = UIColor.whiteColor()
        collection.dataSource = self
        collection.contentInset = UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0)
        
        // 注册Cell
//        collection.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        let nib = UINib(nibName: "\(CustomCell.self)", bundle: nil)
        collection.registerNib(nib, forCellWithReuseIdentifier: cellIdentifier)
        
        
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
//        return 10
        return itemList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        // 从缓存池中获取cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! CustomCell
        
        
        // 获取模型
//        let content = self.dict[indexPath.item]
//        cell.contentImageView.image = UIImage(named: content.img)
//        cell.contentLabel.text = content.name
        
        let items = self.itemList[indexPath.item]
        
//        guard let image = items.icon else {
//            return cell
//        }
//        cell.contentImageView.image = UIImage(named: image)
        
//        cell.contentImageView.image = items.image
//        cell.contentLabel.text = items.name
        
        cell.image = items.image
        cell.text = items.name
        
        return cell
    }
}