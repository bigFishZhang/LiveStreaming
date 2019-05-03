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
    
    convenience init?(hex:String,alpha:CGFloat = 1.0) {
        //1字符串长度是否符合
        guard hex.count >= 6 else {
            return nil
        }
        //2字符串转成大写
        var tmpHex = hex.uppercased()
        //3判断开头 0x/##
        if tmpHex.hasPrefix("0x") || tmpHex.hasPrefix("##"){
            tmpHex = (tmpHex as NSString).substring(from: 2)
        }
        // #开头
        if tmpHex.hasPrefix("#"){
            tmpHex = (tmpHex as NSString).substring(from: 1)
        }
        
        // 4 分别取出rgb
        var range = NSRange(location: 0, length: 2)
        let rHex =  (tmpHex as NSString).substring(with: range)
        range.location = 2
        let gHex =  (tmpHex as NSString).substring(with: range)
        range.location = 4
        let bHex =  (tmpHex as NSString).substring(with: range)
        
        // 5 将16进制转成数字
        var red:UInt32 = 0,green:UInt32 = 0 , blue:UInt32 = 0
        Scanner(string: rHex).scanHexInt32(&red)
        Scanner(string: gHex).scanHexInt32(&green)
        Scanner(string: bHex).scanHexInt32(&blue)
        
        self.init(r:CGFloat(red),g:CGFloat(green),b:CGFloat(blue))
        
    }
    
    
    class func gloablBackgroundColor() -> UIColor {
        return UIColor(r: 248, g: 249, b: 247)
    }
    
    class func gloablStyleColor() -> UIColor {
        return UIColor(r: 245, g: 90, b: 93)
    }
    
    class func randomColor() -> UIColor {
        return  UIColor(r: CGFloat(arc4random_uniform(256)),
                        g: CGFloat(arc4random_uniform(256)),
                        b: CGFloat(arc4random_uniform(256)))
    }
    
    class func getRGBDelta(_ firstColor:UIColor,_ secondColor:UIColor) -> (CGFloat,CGFloat,CGFloat){
        
        let firstRGB = firstColor.getRGB()
        let secondRGB = secondColor.getRGB()
        
        return (firstRGB.0 - secondRGB.0,firstRGB.1 - secondRGB.1,firstRGB.2 - secondRGB.2)
        
    }
    
    func getRGB()->(CGFloat,CGFloat,CGFloat){
        
        guard let cmps = cgColor.components else{
            
            fatalError("颜色不是RGB方式传入")
        }
        return (cmps[0] * 255,cmps[1] * 255,cmps[2] * 255)
    }
    
    
}


