//
//  RecommendViewController.swift
//  DYLiveDemo
//
//  Created by xiaokui wu on 12/17/16.
//  Copyright © 2016 wxk. All rights reserved.
//

import UIKit

private let kItemMargin : CGFloat = 10.0
private let kItemW : CGFloat = (kScreenWidth - 3 * kItemMargin) / 2
private let kNormalItemH : CGFloat = kItemW * 3 / 4
private let kPrettyItemH : CGFloat = kItemW * 4 / 3
private let kHeaderViewH : CGFloat = 50

private let kHeaderViewId = "kHeaderViewId"
private let kNormalCellId = "kNormalCellId"
private let kPrettyCellId = "kPrettyCellId"

class RecommendViewController: UIViewController {
    
    //MARK: - 懒加载
    private lazy var collectionView : UICollectionView = {[unowned self] in
        
        let layout = UICollectionViewFlowLayout()
        //layout.itemSize = CGSize(width: kItemW, height: kNormalItemH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = kItemMargin
        // 组头size
        layout.headerReferenceSize = CGSize(width: kScreenWidth, height: kHeaderViewH)
        // 内边距
        layout.sectionInset = UIEdgeInsets(top: 0, left: kItemMargin, bottom: 0, right: kItemMargin)
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        // 让collectionView随着self.view的宽高而变化
        collectionView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = UIColor.whiteColor()
        
        return collectionView
    }()

    //MARK: - 系统函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.registerNib(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderViewId)
        
        collectionView.registerNib(UINib(nibName: "CollectionNormalCell", bundle: nil), forCellWithReuseIdentifier: kNormalCellId)
        
        collectionView.registerNib(UINib(nibName: "CollectionPrettyCell", bundle: nil), forCellWithReuseIdentifier: kPrettyCellId)
        
        setupUI()
    }


}

//MARK: - setup UI
extension RecommendViewController{
    func setupUI() {
        view.addSubview(collectionView)
    }
}



//MARK: - UICollectionViewDataSource
extension RecommendViewController : UICollectionViewDataSource{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 12
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 8
        }
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell : UICollectionViewCell
        
        if indexPath.section == 1 {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(kPrettyCellId, forIndexPath: indexPath)
        }else{
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(kNormalCellId, forIndexPath: indexPath)
        }
  
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: kHeaderViewId, forIndexPath: indexPath)
        
        
        return headerView
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension RecommendViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if indexPath.section == 1 {
            return CGSize(width: kItemW, height: kPrettyItemH)
        }
        return CGSize(width: kItemW, height: kNormalItemH)
    }
}

















