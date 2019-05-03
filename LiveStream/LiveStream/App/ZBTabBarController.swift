//
//  ZBTabBarController.swift
//  News
//
//  Created by bigfish on 2019/4/10.
//  Copyright © 2019 zzb. All rights reserved.
//

import UIKit

class ZBTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //title颜色
        let tabbar = UITabBar.appearance()
        tabbar.tintColor = UIColor(red: 196/255.0, green: 157/255.0, blue: 109/255.0, alpha: 1.0)
        //添加子控制器
        addChildViewControllers()

    }
    
    /// 添加子控制器
    func addChildViewControllers() {
        //添加4个子控制器
        addChild(childController: HomeViewController(), title: "首页", imageName: "live-n", selectImageName: "live-p")
        addChild(childController: RankViewController(), title: "排行", imageName: "ranking-n", selectImageName: "ranking-p")
        addChild(childController: FoundViewController(),title: "发现", imageName: "found-n", selectImageName: "found-p")
        addChild(childController: MineViewController(), title: "我的", imageName: "mine-n", selectImageName: "mine-p")
        //通过KVC 设置 tabBar 来添加修改Button
//        setValue(ZBTabBar(), forKey: "tabBar")
    }
    
    /// 初始化子控制器
    func addChild(childController: UIViewController,
                            title:String,
                            imageName:String,
                            selectImageName:String) {
        //设置Tabbar文字和图片
        childController.title = title
        childController.tabBarItem.image = UIImage(named: imageName)
        childController.tabBarItem.selectedImage = UIImage(named: selectImageName)
        //添加导航控制器为TabbarController 的子控制器
        let navVC = ZBNavigationController.init(rootViewController: childController)
        addChild(navVC)

    }
    
    
    
    
    
    


}
