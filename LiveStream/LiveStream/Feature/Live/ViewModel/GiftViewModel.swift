//
//  GiftViewModel.swift
//  LiveStream
//
//  Created by zhang zhengbin on 2019/5/16.
//  Copyright © 2019 zzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class GiftViewModel {
    
    lazy var giftlistData:[GiftPackage] = [GiftPackage]()
    
}


extension GiftViewModel{
    

    
    func loadGiftData(finishedCallback:@escaping ()->())  {
        // http://qf.56.com/pay/v4/giftList.ios?type=0&page=1&rows=150
        if giftlistData.count != 0 { finishedCallback() }
        
        NetworkTools.requestData(.get, URLString: "http://qf.56.com/pay/v4/giftList.ios", parameters: ["type" : 0, "page" : 1, "rows" : 150], finishedCallback: { result in
            
            guard let resultDict = result as? [String : Any] else {
                print("request failed!  resultDict " );
                print(result);
                return
            }
            
            guard let dataDict = resultDict["message"] as? [String : Any] else {
                print("request failed! dataDict ");
                return
                
            }
            
            for i in 0..<dataDict.count {
                guard let dict = dataDict["type\(i+1)"] as? [String : Any] else { continue }
                self.giftlistData.append(GiftPackage(dict: dict))
            }
            
            self.giftlistData = self.giftlistData.filter({ return $0.t != 0 }).sorted(by: { return $0.t > $1.t })
            
            finishedCallback()
        })
    }
}
