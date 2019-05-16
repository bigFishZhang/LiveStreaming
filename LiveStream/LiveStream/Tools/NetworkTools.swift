//
//  NetworkTools.swift
//  LiveStream
//
//  Created by zzb on 2019/5/3.
//  Copyright © 2019 zzb. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
enum MethodType {
    case get
    case post
}

class NetworkTools {
    
    /// 网络请求
    ///
    /// - Parameters:
    ///   - type: 类型
    ///   - URLString: <#URLString description#>
    ///   - parameters: <#parameters description#>
    ///   - finishedCallback: <#finishedCallback description#>
    
    class func requestData(_ type : MethodType, URLString : String, parameters : [String : Any]? = nil, finishedCallback :  @escaping (_ result : Any) -> ()) {
        
        // 1.获取类型
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        
        // 2.发送网络请求
        Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { (response) in
            
            // 3.获取结果
            guard let result = response.result.value else {
                print(response.result.error!)
                finishedCallback(response)//for test
                return
            }
            // 4.将结果回调出去
            finishedCallback(result)
        }

    }
    
}
