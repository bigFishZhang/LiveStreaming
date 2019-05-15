//
//  EmoticonViewCell.swift
//  LiveStream
//
//  Created by bigfish on 2019/5/15.
//  Copyright © 2019 zzb. All rights reserved.
//

import UIKit

class EmoticonViewCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    
    var emotion : Emoticon? {
        didSet {
            iconImageView.image = UIImage(named: emotion!.emoticonName)            
        }
    }
    
    
 
}
