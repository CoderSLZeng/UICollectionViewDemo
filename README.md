# UICollectionViewDemo
## UICollectionView基础用法和简单自定义
注：本文通过几个实例来讲讲UICollectionView基本用法

本次要实现的两个效果

![](/Users/Anthony/Desktop/UICollectionViewDemo/UICollectionViewDemo/UICollectionViewDemo/README_IMG/Snip20170223_1.gif)

第一个界面是一个普通的流布局 UICollectionViewFlowLayout， 第二个界面是自定义的一个圆形布局。加了点手势操作和动画。老规矩。后面会附上源码

首先来看下基本用法 

### 1、UICollectionView基础用法

简单的UICollectionView 相当于GridView ，一个多列的UItableView ,然而UICollectionView 跟UItableView 的操作也非常相似 。都是会设置有一个DataSource 和一个delegate 标准的UICollectionView包含三个部分，它们都是UIView的子类：

* cells 单元格用来展示内容的，可以设置所有的大小 也可以指定不同尺寸和不同的内容

* Supplementary Views 追加视图 如果你对UITableView比较熟悉的话，可以理解为每个Section的Header或者Footer，用来标记每个section的view

* Decoration Views 装饰视图 这是每个section的背景

UICollectionView和UITableView最大的不同就是UICollectionViewLayout，UICollectionViewLayout可以说是UICollectionView的大脑和中枢，它负责了将各个cell、Supplementary View和Decoration Views进行组织，为它们设定各自的属性。包括位置、尺寸、层级、形状等等 。。

Layout决定了UICollectionView是如何显示在界面上的。在展示之前，一般需要生成合适的UICollectionViewLayout子类对象，并将其赋予CollectionView的collectionViewLayout属性

下面我们ViewController.swift视图控制器中实现一个最简单的Demo

在viewDidLoad函数中初始化基本属性

```
		// 布局
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical // 滚动方向
        layout.itemSize = CGSize(width: 60, height: 70) // 设置所有cell的size
        layout.minimumLineSpacing = 10.0 // 上下间隔
        layout.minimumInteritemSpacing = 5.0 // 左右间隔
        layout.headerReferenceSize = CGSize(width: 20, height: 20)
        layout.footerReferenceSize = CGSize(width: 20, height: 20)
        
```

这里创建了基本的流布局 设置了一些基本属性。

然后其他的设置和UITableView差不多

```
		// collectionView
        let collection = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collection.backgroundColor = UIColor.whiteColor() // 背景色
        collection.dataSource = self // 数据源
        collection.contentInset = UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0) // 内边距
        view.addSubview(collection)
```

因为初始的背景色是黑色的，这里指定了背景色

然后实现下面三个基本的方法，就能正常跑了 。最要是cell的显示方法

```
//==========================================================================================================
// MARK: - UICollectionViewDataSource
//==========================================================================================================

extension ViewController: UICollectionViewDataSource
{
    
    /**
     系统默认返回1个分区，可不写
    // 设置分区个数
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
     */
    
    /**
     设置每个分区元素个数
     */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    /**
     设置元素内容
     */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        // 创建cell
        return cell
    }
    
}
```

为了得到高效的View，对于cell的重用是必须的，避免了不断生成和销毁对象的操作，在UICollectionView中使用以下方法进行注册：

```
registerClass:forCellWithReuseIdentifier:
registerClass:forSupplementaryViewOfKind:withReuseIdentifier:
registerNib:forCellWithReuseIdentifier:
registerNib:forSupplementaryViewOfKind:withReuseIdentifier:
```

先注册 ，使用一个Identifier ，加入重用队列。要是在重用队列里没有可用的cell的话，runtime将自动帮我们生成并初始化一个可用的cell。

我们这里是自己用xib 画了个cell 

![](/Users/Anthony/Desktop/UICollectionViewDemo/UICollectionViewDemo/UICollectionViewDemo/README_IMG/Snip20170223_2.png)

一个很简单的cell ，把它的class 设置成我们自定义的M CustomCell, CustomCell继承自UICollectionViewCell ，把这两个拖成它的成员属性

建议另新增两个成员属性，在其didSet中处理对应属性的业务，方便传出去

![](/Users/Anthony/Desktop/UICollectionViewDemo/UICollectionViewDemo/UICollectionViewDemo/README_IMG/Snip20170223_3.png)

```
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
```

然后，在我们的视图控制器中的viewDidLoad进行注册

```
// 注册Cell
let nib = UINib(nibName: "\(CustomCell.self)", bundle: nil)
collection.registerNib(nib, forCellWithReuseIdentifier: cellIdentifier)
```

然后在cellForItemAtIndexPath 里面就能这样取了

```
// 从缓存池中获取cell
let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! CustomCell
```
我们事先创建了数目模型CellItem，用来存放cell的icon和name

```
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
```
然后在ViewController.swift控制器中懒加载一个模型属性

```
/// 数据模型
lazy var itemsList: [CellItem] = {
	() -> [CellItem]
   in
        
   return CellItem.itemList()
}()
```
这里返回元素个数就可以这么写了

```
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsList.count
    }
```

元素的内容就可以很简单的设置了 

```
/**
     设置元素内容
     */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        // 从缓存池中获取cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! CustomCell
        
        // 获取模型
        let items = self.itemsList[indexPath.item]
        
        cell.image = items.image
        cell.text = items.name
        return cell
    }

```

现在运行，第一个页面的效果就有了

![](/Users/Anthony/Desktop/UICollectionViewDemo/UICollectionViewDemo/UICollectionViewDemo/README_IMG/Snip20170223_4.png)

但让还有向UITableView中样很多的方法去设置别的，比如单个cell的大小

```
func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
            return CGSizeMake(150, 150)
    }
```
点击cell

```
// 点击元素
func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
      print("点击了第\(indexPath.section) 分区 ,第\(indexPath.row) 个元素")
    }
```
还有很多，自己慢慢尝试。

下面看看自定义的

### 2、自定义UICollectionViewLayout
UICollectionViewLayoutAttributes是一个非常重要的类，先来看看property列表：

```
@property (nonatomic) CGRect frame
@property (nonatomic) CGPoint center
@property (nonatomic) CGSize size
@property (nonatomic) CATransform3D transform3D
@property (nonatomic) CGFloat alpha
@property (nonatomic) NSInteger zIndex
@property (nonatomic, getter=isHidden) BOOL hidden
```
可以看到，UICollectionViewLayoutAttributes的实例中包含了诸如边框，中心点，大小，形状，透明度，层次关系和是否隐藏等信息。和DataSource的行为十分类似，当UICollectionView在获取布局时将针对每一个indexPath的部件（包括cell，追加视图和装饰视图），向其上的UICollectionViewLayout实例询问该部件的布局信息，这个布局信息，就以UICollectionViewLayoutAttributes的实例的方式给出。

UICollectionViewLayout的功能为向UICollectionView提供布局信息，不仅包括cell的布局信息，也包括追加视图和装饰视图的布局信息。实现一个自定义layout的常规做法是继承UICollectionViewLayout类，然后重载下列方法：

```
// 返回collectionView的内容的尺寸
-(CGSize)collectionViewContentSize
 
// 返回rect中的所有的元素的布局属性
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect

// 返回对应于indexPath的位置的cell的布局属性
-(UICollectionViewLayoutAttributes )layoutAttributesForItemAtIndexPath:(NSIndexPath )indexPath

// 返回对应于indexPath的位置的追加视图的布局属性，如果没有追加视图可不重载
-(UICollectionViewLayoutAttributes )layoutAttributesForSupplementaryViewOfKind:(NSString )kind atIndexPath:(NSIndexPath *)indexPath

// 返回对应于indexPath的位置的装饰视图的布局属性，如果没有装饰视图可不重载
-(UICollectionViewLayoutAttributes * )layoutAttributesForDecorationViewOfKind:(NSString)decorationViewKind atIndexPath:(NSIndexPath )indexPath

// 当边界发生改变时，是否应该刷新布局。如果YES则在边界变化（一般是scroll到其他地方）时，将重新计算需要的布局信息。
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
```
* 在初始化一个UICollectionViewLayout实例后，会有一系列准备方法被自动调用，以保证layout实例的正确。
* 首先，-(void)prepareLayout将被调用，默认下该方法什么没做，但是在自己的子类实现中，一般在该方法中设定一些必要的layout的结构和初始需要的参数等。

* 之后，-(CGSize) collectionViewContentSize将被调用，以确定collection应该占据的尺寸。注意这里的尺寸不是指可视部分的尺寸，而应该是所有内容所占的尺寸。collectionView的本质是一个scrollView，因此需要这个尺寸来配置滚动行为。

* 接下来-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect被调用，这个没什么值得多说的。初始的layout的外观将由该方法返回的UICollectionViewLayoutAttributes来决定。

* 另外，在需要更新layout时，需要给当前layout发送 -invalidateLayout，该消息会立即返回，并且预约在下一个loop的时候刷新当前layout，这一点和UIView的setNeedsLayout方法十分类似。在-invalidateLayout后的下一个collectionView的刷新loop中，又会从prepareLayout开始，依次再调用-collectionViewContentSize和-layoutAttributesForElementsInRect来生成更新后的布局。

下面看下demo
首先创建一个类CircularLayout.swift继承自UICollectionViewLayou 
声明一些基本的属性

```
    //==========================================================================================================
    // MARK: - 自定义基本属性
    //==========================================================================================================

    private let ITEM_SIZE: CGFloat = 70.0
    private var insertIndexPaths = [NSIndexPath]()
    
    private var _cellCount: Int?
    private var _collectionSize: CGSize?
    private var _center: CGPoint?
    private var _radius: CGFloat?
```
重写父类函数的初始化一些基本信息

```
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
```
可见区域


```
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
```

layoutAttributesForItemAtIndexPath 对UICollectionViewLayoutAttributes 的一些属性进行设置 ，前面列出过 ，然后layoutAttributesForElementsInRect 方法返回所有UICollectionViewLayoutAttributes ， 以数组的方式

```
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
        
        // 每个item之间的角度
        let angleDelta = M_PI * 2 / Double(cellCount)
        
        // 计算当前item的角度
        let angle = Double(indexPath.item) * angleDelta
        
        let x = Double(center.x) + Double(radius) * cos(angle)
        let y = Double(center.y) + Double(radius) * sin(angle)
        
        attrs.center = CGPoint(x: x, y: y)
        
        
        return attrs
    }
```

新建控制器NextPageViewController.swift实现代码同上面的控制器

使用的时候把基本用法里的layout换掉

```
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
```

在viewDidLoad函数中实现导航栏右边按钮的点击切换布局方式

```
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "切换布局", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.changeLayout))
```
可以通过setCollectionViewLayout 方法来切换layout 

```
//==========================================================================================================
    // MARK: - 处理监听事件
    //==========================================================================================================
    /**
     更改布局
    */
    func changeLayout() {
        
        if layout is CircularLayout {
            layout = UICollectionViewFlowLayout()
            let flowLayout = (layout as! UICollectionViewFlowLayout)
            flowLayout.itemSize = CGSize(width: 70, height: 70)
        } else {
            layout = CircularLayout()

        }
        
        self.collection.setCollectionViewLayout(layout, animated: true)
    }

```
在collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell更改元素内容

```
cell.layer.cornerRadius = 35
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.blackColor().CGColor
```

运行程序，圆就出现了

![](/Users/Anthony/Desktop/UICollectionViewDemo/UICollectionViewDemo/UICollectionViewDemo/README_IMG/Snip20170223_5.gif)

然后在然后给这个界面添加手势给这个界面添加手势

```
// 添加手势
        let tapRecognize = UITapGestureRecognizer(target: self, action: #selector(self.hadleTap(_:)))
        collection.addGestureRecognizer(tapRecognize)
```

```
/**
     监听手势点击
     
     - parameter sender: 手势识别器
     */
    func hadleTap(sender: UITapGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Ended {
            let tapPoint = sender.locationInView(self.collection)
            
            if let indexPath = self.collection.indexPathForItemAtPoint(tapPoint)
            {
                
                print("删除点击的cell")
                
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
```

如注释掉这段GCD的代码也是可以执行的，就是没有动画。

这个方法performBatchUpdates:completion 可以用来对collectionView中的元素进行批量的插入，删除，移动等操作，同时将触发collectionView所对应的layout的对应的动画。相应的动画由layout中的下列四个方法来定义：

```
initialLayoutAttributesForAppearingItemAtIndexPath:
initialLayoutAttributesForAppearingDecorationElementOfKind:atIndexPath:
finalLayoutAttributesForDisappearingItemAtIndexPath:
finalLayoutAttributesForDisappearingDecorationElementOfKind:atIndexPath
```

默认的动画是这样的 

![](/Users/Anthony/Desktop/UICollectionViewDemo/UICollectionViewDemo/UICollectionViewDemo/README_IMG/Snip20170223_6.gif)

可以自定义动画

每次重新给出layout时都会调用prepareLayout，这样在以后如果有collectionView大小变化的需求时也可以自动适应变化。

```
    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        // Must call super
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
```
首先会调用prepareForCollectionViewUpdates，我们在这里拿到那个新增的NSIndexPath ，然后initialLayoutAttributesForAppearingItemAtIndexPath 在这个方法中设置一些初始位置。

看下效果

![](/Users/Anthony/Desktop/UICollectionViewDemo/UICollectionViewDemo/UICollectionViewDemo/README_IMG/Snip20170223_7.gif)

现在动画从中间散出去的
(本实例使用xcode 7.3.1 ， Swift 3.0) 

最后附上源码：https://github.com/CoderSLZeng/UICollectionViewDemo









