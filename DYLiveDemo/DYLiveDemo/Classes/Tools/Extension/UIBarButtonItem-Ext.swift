//
//  UIBarButtonItem-Ext.swift
//  DYLiveDemo
//
//  Created by xiaokui wu on 12/16/16.
//  Copyright © 2016 wxk. All rights reserved.
//

import UIKit

extension UIBarButtonItem{

    /* 类方法扩展，swift鼓励用构造函数
    class func createItem(imageName: String, highImageName: String, size: CGSize) -> UIBarButtonItem{
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), forState: .Normal)
        btn.setImage(UIImage(named: highImageName), forState: .Highlighted)
        btn.frame = CGRect(origin: CGPointZero, size: size)
        
        return UIBarButtonItem(customView: btn)
    }
     */
    // 在extension中只能扩展便捷构造函数， 1必须以convenience开头，2必须明确调用指定构造函数
    convenience init(imageName: String, highImageName: String = "", size: CGSize = CGSizeZero) {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), forState: .Normal)
        if highImageName != "" {
            btn.setImage(UIImage(named: highImageName), forState: .Highlighted)
        }
        if size == CGSizeZero {
            btn.sizeToFit()
        }else{
            btn.frame = CGRect(origin: CGPointZero, size: size)
        }
        
        self.init(customView: btn)
    }
}
