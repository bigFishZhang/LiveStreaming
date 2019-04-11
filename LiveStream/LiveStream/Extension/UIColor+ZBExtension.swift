//
//  UIColor+ZBExtension.swift
//  News
//
//  Created by bigfish on 2019/4/11.
//  Copyright © 2019 zzb. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(r:CGFloat,g:CGFloat,b:CGFloat,alpha:CGFloat = 1.0) {
        
        self.init(red: r / 255.0, green: g / 255.0 , blue: b / 255.0, alpha: alpha)
        // ios 10
//        self.init(displayP3Red: r / 255.0, green: g / 255.0 , blue: b / 255.0, alpha: alpha)
    }
    
    class func gloablBackgroundColor() -> UIColor {
        return UIColor(r: 248, g: 249, b: 247)
    }
    
    class func gloablStyleColor() -> UIColor {
        return UIColor(r: 245, g: 90, b: 93)
    }
    
    
}


