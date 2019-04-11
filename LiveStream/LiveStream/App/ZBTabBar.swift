//
//  ZBTabBar.swift
//  News
//
//  Created by bigfish on 2019/4/10.
//  Copyright © 2019 zzb. All rights reserved.
//

import UIKit

class ZBTabBar: UITabBar {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(publishButton)
    }
    
    private lazy var publishButton:UIButton = {
        let publishButton = UIButton(type: UIButton.ButtonType.custom)
        publishButton.setBackgroundImage(UIImage(named: "feed_publish_44x44_"), for: .normal)
        publishButton.setBackgroundImage(UIImage(named: "feed_publish_press_44x44_"), for: .selected)
        publishButton.sizeToFit()
        return publishButton
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //当前tabbar 的宽高
        let width  = frame.width
        let height = frame.height
        
        publishButton.center = CGPoint(x: width * 0.5, y: height * 0.5 - 8)
        
        let buttonW:CGFloat  = width * 0.2
        let buttonH:CGFloat  = height
        let buttonY:CGFloat  = 0
        var index = 0
        for button in subviews {
            if !button.isKind(of: NSClassFromString("UITabBarButton")!) {continue}
            let buttonX = buttonW * (index > 1 ? CGFloat(index + 1) : CGFloat(index)) //第三个是添加的 所以 +1 整体后移
            button.frame = CGRect(x: buttonX, y: buttonY, width: buttonW, height: buttonH)
            index += 1
        }
        
    }
    
 
}
