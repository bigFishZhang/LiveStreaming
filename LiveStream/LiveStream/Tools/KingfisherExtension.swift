//
//  KingfisherExtension.swift
//  LiveStream
//
//  Created by zzb on 2019/5/3.
//  Copyright © 2019 zzb. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    /// 加载网络图片
    ///
    /// - Parameters:
    ///   - URLString: <#URLString description#>
    ///   - placeHolderName: <#placeHolderName description#>
    func setImage(_ URLString : String?, _ placeHolderName : String?) {
        guard let URLString = URLString else {
            return
        }
        
        guard let placeHolderName = placeHolderName else {
            return
        }
        
        guard let url = URL(string: URLString) else { return }
        kf.setImage(with: url, placeholder : UIImage(named: placeHolderName))
    }
    
    
    
}

