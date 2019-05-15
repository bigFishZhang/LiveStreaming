//
//  EmoticonViewModel.swift
//  LiveStream
//
//  Created by bigfish on 2019/5/15.
//  Copyright © 2019 zzb. All rights reserved.
//

import UIKit

class EmoticonViewModel {
    
    static let shareInstance : EmoticonViewModel = EmoticonViewModel()
    
    lazy var packages : [EmoticonPackage] = [EmoticonPackage]()
    
    init() {
        packages.append(EmoticonPackage(plistName: "QHNormalEmotionSort.plist"))
        packages.append(EmoticonPackage(plistName: "QHSohuGifSort.plist"))
    }
    
}
