//
//  UIColor-Ext.swift
//  DYLiveDemo
//
//  Created by xiaokui wu on 12/16/16.
//  Copyright © 2016 wxk. All rights reserved.
//

import UIKit

extension UIColor{
    
    convenience init(r : CGFloat, g : CGFloat, b : CGFloat) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
}