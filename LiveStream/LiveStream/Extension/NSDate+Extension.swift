//
//  NSDate+Extension.swift
//  LiveStream
//
//  Created by zzb on 2019/5/3.
//  Copyright © 2019 zzb. All rights reserved.
//

import Foundation

extension Date {
    
    /// 获取当前时间
    ///
    /// - Returns: 返回当前时间
    static func getCurrentTime() -> String {
        let nowDate = Date()
        
        let interval = Int(nowDate.timeIntervalSince1970)
        
        return "\(interval)"
    }
}
