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
        tabbar.tintColor = UIColor(red: 245/255.0, green: 90/255.0, blue: 93/255.0, alpha: 1.0)
        //添加子控制器
        addChildViewControllers()

    }
    
    /// 添加子控制器
    func addChildViewControllers() {
        //添加4个子控制器
        addChild(childController: HomeViewController(), title: "首页", imageName: "home_tabbar_32x32_", selectImageName: "home_tabbar_press_32x32_")
        addChild(childController: VideoViewController(), title: "视频", imageName: "video_tabbar_32x32_", selectImageName: "video_tabbar_press_32x32_")
        addChild(childController: HuoshanViewController(), title: "火山", imageName: "huoshan_tabbar_32x32_", selectImageName: "huoshan_tabbar_press_32x32_")
        addChild(childController: MineViewController(), title: "我的", imageName: "mine_tabbar_32x32_", selectImageName: "mine_tabbar_press_32x32_")
        //通过KVC 设置 tabBar 来添加修改Button
        setValue(ZBTabBar(), forKey: "tabBar")
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
