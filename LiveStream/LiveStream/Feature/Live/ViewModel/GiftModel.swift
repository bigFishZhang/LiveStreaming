//
//  GiftModel.swift
//  LiveStream
//
//  Created by bigfish on 2019/5/16.
//  Copyright © 2019 zzb. All rights reserved.
//

import UIKit

class GiftModel:BaseModel{
    var img2 : String = "" // 图片
    var coin : Int = 0 // 价格
    var subject : String = "" { // 标题
        didSet {
            if subject.contains("(有声)") {
                subject = subject.replacingOccurrences(of: "(有声)", with: "")
            }
        }
    }
    
    
}
