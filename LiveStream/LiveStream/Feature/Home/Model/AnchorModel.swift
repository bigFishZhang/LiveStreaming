//
//  AnchorModel.swift
//  LiveStream
//
//  Created by zzb on 2019/5/3.
//  Copyright © 2019 zzb. All rights reserved.
//

import UIKit

class AnchorModel: BaseModel {
   @objc var roomid : Int = 0
   @objc var name : String = ""
   @objc var pic51 : String = ""
   @objc var pic74 : String = ""
   @objc  var live : Int = 0 // 是否在直播
   @objc var push : Int = 0 // 直播显示方式
   @objc var focus : Int = 0 // 关注数
    
   @objc  var isEvenIndex : Bool = false
}


   
