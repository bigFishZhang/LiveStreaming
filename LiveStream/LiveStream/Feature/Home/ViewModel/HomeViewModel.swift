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
            
//            guard let resultDict = result as? [String : Any] else {
//                print("resultDict is nil")
//                return
//            }
//            guard let messageDict = resultDict["message"] as? [String : Any] else {
//                print("resultDict  messageis nil")
//                return
//            }
//            guard let dataArray = messageDict["anchors"] as? [[String : Any]] else {
//                print("resultDict  anchors nil")
//                return
//            }
//
            
            let arr = [["roomid":520515,
                        "name":"千熙修仙中~",
                        "pic51":"https://file.qf.56.com/p/group1/M11/96/69/MTAuMTguMTcuMTg3/MTAwMTA2XzE1NTUzODkxNjEwNDI=/cut@m=crop,x=0,y=0,w=509,h=509_cut@m=resize,w=640,h=640.jpg",
                        "pic74":"https://file.qf.56.com/p/group1/M01/A1/A9/MTAuMTguMTcuMTg2/MTAwMTA2XzE1NDU0OTA2NzM5NDc=/cut@m=crop,x=19,y=23,w=1033,h=1033_cut@m=resize,w=640,h=640.jpg",
                        "live":0,
                        "push":1,
                        "focus":888],["roomid":520056,
                                      "name":"楚楚5月6号生日",
                                      "pic51":"https://file.qf.56.com/f/upload/photo/activity/app/201903260528091553592489694.gif",
                                      "pic74":"https://file.qf.56.com/f/upload/photo/activity/app/201903260528091553592489694.gif",
                                      "live":1,
                                      "push":1,
                                      "focus":999],["roomid":520868,
                        "name":"木桐感谢陪伴~",
                        "pic51":"https://file.qf.56.com/p/group1/M01/A1/A9/MTAuMTguMTcuMTg2/MTAwMTA2XzE1NDU0OTA2NzM5NDc=/cut@m=crop,x=19,y=23,w=1033,h=1033_cut@m=resize,w=640,h=640.jpg",
                        "pic74":"https://file.qf.56.com/p/group1/M01/A1/A9/MTAuMTguMTcuMTg2/MTAwMTA2XzE1NDU0OTA2NzM5NDc=/cut@m=crop,x=19,y=23,w=1033,h=1033_cut@m=resize,w=640,h=640.jpg",
                        "live":1,
                        "push":1,
                        "focus":888],["roomid":6354480,
                        "name":"新人宝儿热舞中~",
                        "pic51":"https://file.qf.56.com/p/group2/M05/79/FE/MTAuMTguMTcuMTg4/MTAwMTA2XzE1NTUxMjE3MDg0OTk=/cut@m=crop,x=114,y=54,w=824,h=824_cut@m=resize,w=100,h=100.jpg",
                        "pic74":"https://file.qf.56.com/p/group2/M05/79/FE/MTAuMTguMTcuMTg4/MTAwMTA2XzE1NTUxMjE3MDg0OTk=/cut@m=crop,x=114,y=54,w=824,h=824_cut@m=resize,w=640,h=640.jpg",
                        "live":1,
                        "push":1,
                        "focus":999],["roomid":520205,
                                      "name":"可爱灵.",
                                      "pic51":"https://file.qf.56.com/p/group1/M09/F0/C0/MTAuMTguMTcuMTg2/MTAwMTA2XzE1NTY0NjE3NTQ1NDc=/cut@m=crop,x=0,y=0,w=640,h=640_cut@m=resize,w=640,h=640.png",
                                      "pic74":"https://file.qf.56.com/p/group1/M09/F0/C0/MTAuMTguMTcuMTg2/MTAwMTA2XzE1NTY0NjE3NTQ1NDc=/cut@m=crop,x=0,y=0,w=640,h=640_cut@m=resize,w=640,h=640.png",
                                      "live":1,
                                      "push":1,
                                      "focus":777],["roomid":7181292,
                                                    "name":"露露等你宠",
                                                    "pic51":"https://file.qf.56.com/p/group2/M10/BB/CC/MTAuMTguMTcuMTg4/MTAwMTA2XzE1NTU4NTY4Mzc0Nzk=/cut@m=crop,x=0,y=0,w=640,h=640_cut@m=resize,w=100,h=100.jpg",
                                                    "pic74":"https://file.qf.56.com/p/group1/M12/BB/8F/MTAuMTguMTcuMTg3/MTAwMTA2XzE1NTU4NTQ0MzI0Mzg=/cut@m=crop,x=0,y=0,w=640,h=640_cut@m=resize,w=640,h=640.jpg",
                                                    "live":0,
                                                    "push":1,
                                                    "focus":3213],]
            for (index, dict) in arr.enumerated() {
                let anchor = AnchorModel(dict: dict)
                anchor.isEvenIndex = index % 2 == 0
                self.anchorModels.append(anchor)
            }
            
            finishedCallback()
        })
    }
}

