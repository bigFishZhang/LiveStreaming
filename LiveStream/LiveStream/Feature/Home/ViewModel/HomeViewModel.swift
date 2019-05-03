//
//  HomeViewModel.swift
//  LiveStream
//
//  Created by zzb on 2019/5/3.
//  Copyright © 2019 zzb. All rights reserved.
//

import UIKit

class HomeViewModel {
    lazy var anchorModels = [AnchorModel]()
}

extension HomeViewModel {
    
    /// 加载首页数据
    ///
    /// - Parameters:
    ///   - type: <#type description#>
    ///   - index: <#index description#>
    ///   - finishedCallback: <#finishedCallback description#>
    func loadHomeData(type : HomeType, index : Int,  finishedCallback : @escaping () -> ()) {
        NetworkTools.requestData(.get, URLString: "http://qf.56.com/home/v4/moreAnchor.ios", parameters: ["type" : type.type, "index" : index, "size" : 48], finishedCallback: { (result) -> Void in
            
            guard let resultDict = result as? [String : Any] else {
                print("resultDict is nil")
                return
            }
            guard let messageDict = resultDict["message"] as? [String : Any] else {
                print("resultDict  messageis nil")
                return
            }
            guard let dataArray = messageDict["anchors"] as? [[String : Any]] else {
                print("resultDict  anchors nil")
                return
            }
            
            for (index, dict) in dataArray.enumerated() {
                let anchor = AnchorModel(dict: dict)
                anchor.isEvenIndex = index % 2 == 0
                self.anchorModels.append(anchor)
            }
            
            finishedCallback()
        })
    }
}
