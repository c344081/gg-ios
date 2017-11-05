//
//  GGTabBarController.swift
//  gg-iOS
//
//  Created by zoxuner on 2017/10/31.
//  Copyright © 2017年 c344081. All rights reserved.
//

import UIKit

class GGTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewControllers()
    }
    
    // MARK: - public
    
    // MARK: - private
    
    private func setupViewControllers() {
        var vc: UIViewController
        
//        vc = LoginViewController()
        vc = HomeViewController()
        self.setupChildVc(vc, "home", "home_selected")
        
        vc = DiscoveryViewController()
        self.setupChildVc(vc, "search", "search_selected")
        
        vc = MessagesViewController()
        self.setupChildVc(vc, "notify", "notify_selected")
        
        vc = MineViewController()
        self.setupChildVc(vc, "mine", "mine_selected")
    }
    
    private func setupChildVc(_ vc: UIViewController, _ image: String, _ selectedImage: String) {
        let navi = GGNavigationController(rootViewController: vc)
        vc.tabBarItem.image = UIImage(named: image)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        vc.tabBarItem.selectedImage = UIImage(named: selectedImage)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        vc.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        self.addChildViewController(navi)
    }
}
