//
//  PageContentView.swift
//  DYLiveDemo
//
//  Created by xiaokui wu on 12/16/16.
//  Copyright © 2016 wxk. All rights reserved.
//

import UIKit


protocol PageContentViewDelegate : class {
    func pageContentView(contentView: PageContentView, progress : CGFloat, sourceIndex : Int, targetIndex : Int)
}

private let contentCellId = "contentCellId"

class PageContentView: UIView {
    
    //MARK: - 属性
    private var childVcs : [UIViewController]
    private weak var parentVc : UIViewController?
    private var startOffsetX : CGFloat = 0
    weak var delegate : PageContentViewDelegate?
    
    private var isForbidScrollDelegate = false
    
    //MARK: - 懒加载
    private lazy var collectionView : UICollectionView = {[weak self] in// 避免闭包里用self会强引用
        // 创建layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self!.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .Horizontal
        
        //创建collectionView
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.pagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: contentCellId)
        
        return collectionView
        
    }()
    
    //MARK: - 自定义构造函数
    init(frame: CGRect, childVcs: [UIViewController], parentVc: UIViewController?) {
        self.childVcs = childVcs
        self.parentVc = parentVc
        
        super.init(frame: frame);
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK: - 设置UI界面
extension PageContentView{
    
    private func setupUI(){
        // 把所有子控制器添加到父控制器中
        for childVc in childVcs {
            parentVc?.addChildViewController(childVc)
        }
        
        // 添加CollectionView，cell中存放子控制器的view
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}

//MARK: - UICollectionView数据源
extension PageContentView: UICollectionViewDataSource{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(contentCellId, forIndexPath: indexPath)
        
        // 避免复用时出问题，先移除view
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension PageContentView : UICollectionViewDelegate{
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        isForbidScrollDelegate = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if isForbidScrollDelegate {return}// 点击事件
        
        // 定义需要获取的数据
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        
        // 判断是左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOffsetX > startOffsetX{// 左滑
            // 滑动的比例
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)//floor 取整函数
            // 原索引
            sourceIndex = Int(currentOffsetX / scrollViewW)
            // 目的索引
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
            }
            
            if (currentOffsetX - startOffsetX) == scrollViewW{
                progress = 1.0
                targetIndex = sourceIndex
            }
            
            
        }else{
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            targetIndex = Int(currentOffsetX / scrollViewW)
            sourceIndex  = targetIndex + 1
            if sourceIndex >= childVcs.count{
                sourceIndex = childVcs.count - 1
            }
            
        }
        
        // 用代理把数据传出去
        delegate?.pageContentView(self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}

//MARK: - 外部方法
extension PageContentView{
    func setCurrentIndex(index: Int) {
        let offsetX = CGFloat(index) * frame.width
        // 禁止滚动代理
        isForbidScrollDelegate = true
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}
































