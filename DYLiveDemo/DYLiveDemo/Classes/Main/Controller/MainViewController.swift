//
//  MainViewController.swift
//  DYLiveDemo
//
//  Created by xiaokui wu on 12/16/16.
//  Copyright © 2016 wxk. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildVc("Home")
        addChildVc("Live")
        addChildVc("Follow")
        addChildVc("Profile")
    }
    
    private func addChildVc(stroyName: String){
        if let childVc = UIStoryboard(name: stroyName, bundle: nil).instantiateInitialViewController(){
            addChildViewController(childVc)
        }
    }

}
