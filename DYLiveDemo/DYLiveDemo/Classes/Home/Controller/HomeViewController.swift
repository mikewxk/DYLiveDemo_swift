//
//  HomeViewController.swift
//  DYLiveDemo
//
//  Created by xiaokui wu on 12/16/16.
//  Copyright © 2016 wxk. All rights reserved.
//

import UIKit

private let kTitleViewHeight: CGFloat = 40

class HomeViewController: UIViewController {
    
    //MARK: - 懒加载
    private lazy var pageTitleView : PageTitleView = {[weak self] in
        let titleFrame = CGRect(x: 0, y: kStatusBarHeight + kNavigationBarHeight, width: kScreenWidth, height: kTitleViewHeight)
        let titles = ["推荐", "游戏", "娱乐", "趣玩"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
        titleView.delegate = self
        
        return titleView
    }()
    
    private lazy var pageContentView: PageContentView = {[weak self] in
        // 确定内容的frame
        let contentH = kScreenHeight - kStatusBarHeight - kNavigationBarHeight - kTitleViewHeight - kTabBarHeight
        let contentFrame = CGRect(x: 0, y: kStatusBarHeight + kNavigationBarHeight + kTitleViewHeight, width: kScreenWidth, height: contentH)
        
        // 确定所有子控制器
        var childVcs = [UIViewController]()
        childVcs.append(RecommendViewController())
        
        for _ in 0..<3{
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
            childVcs.append(vc)
        }
        
        let contentView = PageContentView(frame: contentFrame, childVcs: childVcs, parentVc: self)
        contentView.delegate = self
        
        return contentView
    }()

    //MARK: - 系统函数
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
    }


}

//MARK: - 设置UI界面
extension HomeViewController{

    private func setupUI(){
        
        // 不要自动调整scrollView的内边距
        automaticallyAdjustsScrollViewInsets = false
        // 导航条
        setupNavBar()
        // 添加头部标题
        view.addSubview(pageTitleView)
        
        // 添加contentView
        view.addSubview(pageContentView)
        pageContentView.backgroundColor = UIColor.purpleColor()
    }
    
    private func setupNavBar() {
        // left
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo")
        
        // right
        let size = CGSize(width: 40, height: 40)
        
        /*
        let historyItem =  UIBarButtonItem.createItem("image_my_history", highImageName: "Image_my_history_click", size: size)
        let searchItem =  UIBarButtonItem.createItem("btn_search", highImageName: "btn_search_click", size: size)
        let qrcodeItem =  UIBarButtonItem.createItem("Image_scan", highImageName: "Image_scan_click", size: size)
         */
        
        let historyItem = UIBarButtonItem(imageName: "image_my_history", highImageName: "Image_my_history_click", size: size)
        let searchItem = UIBarButtonItem(imageName: "btn_search", highImageName: "btn_search_click", size: size)
        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: size)
        
        navigationItem.rightBarButtonItems = [historyItem, searchItem, qrcodeItem]
        
    }
}

//MARK: - PageTitleViewDelegate
extension HomeViewController : PageTitleViewDelegate{
    func pageTitleView(titleView: PageTitleView, selectedIndex index: Int) {
        print(index)
        pageContentView.setCurrentIndex(index)
    }
}



//MARK: - PageContentViewDelegate
extension HomeViewController : PageContentViewDelegate{
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}


















