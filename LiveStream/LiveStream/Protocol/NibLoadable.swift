//
//  NibLoadable.swift
//  LiveStream
//
//  Created by zhang zhengbin on 2019/5/5.
//  Copyright © 2019 zzb. All rights reserved.
//

import UIKit

protocol NibLoadable {
    
}

extension NibLoadable  where Self : UIView {
    static func loadFromNib()->Self{
        return Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)?.first as! Self
    }
}
