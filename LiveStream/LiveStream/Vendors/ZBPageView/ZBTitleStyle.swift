//
//  ZBTitleStyle.swift
//  ZBPageView
//
//  Created by zzb on 2019/4/15.
//  Copyright © 2019 zzb. All rights reserved.
//

import UIKit


class ZBTitleStyle {
    
    /// 普通Title颜色
    var normalColor:UIColor = UIColor(r: 0, g: 0, b: 0)
    /// 选中Title颜色
    var selectedColor:UIColor = UIColor(r: 255, g: 127, b: 0)
    /// Title字体大小
    var fontSize:UIFont = UIFont.systemFont(ofSize: 15.0)
    /// 是否是滚动的Title
    var isScrollEnable:Bool = false
    /// 滚动Title的字体间距
    var titleMargin :CGFloat = 30
    /// 滚动Title的高度
    var titleHeight :CGFloat = 44
    
    /// 是否显示底部滚动条
    var isShowScrollLine:Bool = false
    /// 底部滚动条的高度
    var scrollLineHeight:CGFloat = 2
    /// 底部滚动条的颜色
    var scrollLineColor:UIColor = .orange
    
}
