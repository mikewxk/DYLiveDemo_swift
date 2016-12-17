//
//  PageTitleView.swift
//  DYLiveDemo
//
//  Created by xiaokui wu on 12/16/16.
//  Copyright © 2016 wxk. All rights reserved.
//

import UIKit

//MARK: - 协议
protocol PageTitleViewDelegate : class {// : class 表明代理只能被类遵守
    func pageTitleView(titleView : PageTitleView ,selectedIndex index: Int)
}

//MARK: - 常量
private let kNormalColor : (CGFloat, CGFloat, CGFloat) = (85, 85, 85) // 元组定义rgb颜色
private let kSelectColor : (CGFloat, CGFloat, CGFloat) = (255, 128, 0) // 元组定义rgb颜色
private let kScrollLineHeight: CGFloat = 2

class PageTitleView: UIView {
    
    //MARK: - 属性
    private var titles: [String]
    private var currentIndex = 0
    
    weak var delegate : PageTitleViewDelegate?// 代理指明weak
    
    //MARK: - 懒加载
    private lazy var titleLabels: [UILabel] = [UILabel]()
    
    private lazy var scrollView: UIScrollView = {
    
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.pagingEnabled = false
        scrollView.bounces = false
        
        return scrollView
    }()
    
    private lazy var scrollLine: UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orangeColor()
        return scrollLine
    }()

    //MARK: - 自定义构造函数
    init(frame: CGRect, titles: [String]) {
        self.titles = titles
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension PageTitleView{
    
    private func setupUI(){
        // 滚动视图
        addSubview(scrollView)
        scrollView.frame = bounds
        
        // 标题label
        setupTitleLabels()
        
        // 底线
        setupBottomAndScrollLine()
    }
    
    private func setupTitleLabels() {
        
        let labelW: CGFloat = frame.width / CGFloat(titles.count)
        let labelH: CGFloat = frame.height - kScrollLineHeight
        let labelY: CGFloat = 0
        
        for (index, title) in titles.enumerate(){
            let label = UILabel()
            label.text = title
            label.tag = index
            label.font = UIFont.systemFontOfSize(16.0)
            label.textColor = UIColor.darkGrayColor()
            label.textAlignment = .Center
            
            //frame
            let labelX: CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            // 添加到scrollView中，让label能随着scrollView滚动
            scrollView.addSubview(label)
            
            // 添加到titleLabels数组里
            titleLabels.append(label)
            
            // 给label添加手势
            label.userInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelTap(_:)))
            label.addGestureRecognizer(tapGes)
            
        }
    }
    
    private func setupBottomAndScrollLine(){
        
        // 底部分隔线
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGrayColor()
        let lineH : CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: (frame.height - lineH), width: frame.width, height: lineH)
        addSubview(bottomLine)
        
        // 拿到第一个label
        guard let firstLabel = titleLabels.first else{return}
        firstLabel.textColor = UIColor.orangeColor()
        
        // scrollLine滚动指示线
        scrollView.addSubview(scrollLine)
        // 参照第一个label，设置frame
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrollLineHeight, width: firstLabel.frame.size.width, height: kScrollLineHeight)
    }

}

//MARK: - 内部事件回调
extension PageTitleView{

    @objc private func titleLabelTap(tapGes: UITapGestureRecognizer) {
        
        // 当前选中的label
        guard let currentLabel = tapGes.view as? UILabel else{return}
        
        // 上一个label
        let previousLabel = titleLabels[currentIndex]
        
        // 改变颜色
        previousLabel.textColor = UIColor.darkGrayColor()
        currentLabel.textColor = UIColor.orangeColor()
        
        // 最新选中label的tag值，就是索引值
        currentIndex = currentLabel.tag
        
        // 移动滚动条
        UIView.animateWithDuration(0.15) {
            self.scrollLine.frame.origin.x = currentLabel.frame.origin.x
        }
        
        // 通知代理
        delegate?.pageTitleView(self, selectedIndex: currentIndex)
        
        
    }
}

//MARK: - 外部方法
extension PageTitleView{
    
    func setTitleWithProgress(progress : CGFloat, sourceIndex : Int, targetIndex : Int) {
        
        // 记录最新选中的索引
        currentIndex = targetIndex
        
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        // 滑块滑动
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        // 颜色渐变
        // 变化范围
        let colorDelta = (kSelectColor.0 - kNormalColor.0, kSelectColor.1 - kNormalColor.1, kSelectColor.2 - kNormalColor.2)
        // 选中颜色变为普通颜色
        sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progress, g: kSelectColor.1 - colorDelta.1 * progress, b: kSelectColor.2 - colorDelta.2 * progress)
        
        // 普通颜色变为选中颜色
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)
    }
}








































