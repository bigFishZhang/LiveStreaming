//
//  ZBNavigationController.swift
//  News
//
//  Created by bigfish on 2019/4/10.
//  Copyright © 2019 zzb. All rights reserved.
//

import UIKit

class ZBNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = UIColor.black
        navigationBar.isTranslucent = false
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
       
        
        //pop 手势处理
        guard let targets = interactivePopGestureRecognizer!.value(forKey:  "_targets") as? [NSObject] else { return }
        let targetObjc = targets[0]
        let target = targetObjc.value(forKey: "target")
        let action = Selector(("handleNavigationTransition:"))
        
        let panGes = UIPanGestureRecognizer(target: target, action: action)
        view.addGestureRecognizer(panGes)
        

    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = true
        super.pushViewController(viewController, animated: animated)
    }
  

}
