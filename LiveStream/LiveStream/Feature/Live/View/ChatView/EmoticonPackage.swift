//
//  EmoticonPackage.swift
//  LiveStream
//
//  Created by bigfish on 2019/5/15.
//  Copyright © 2019 zzb. All rights reserved.
//

import UIKit
class EmoticonPackage {
    lazy var emoticons : [Emoticon] = [Emoticon]()
    
    init(plistName : String) {
        guard let path = Bundle.main.path(forResource: plistName, ofType: nil) else {
            print("can't get pist file  " + plistName)
            return
        }
        guard let emoticonArray = NSArray(contentsOfFile: path) as? [String] else {
            print("get name list failed from plist " + path)
            return
        }
        for str in emoticonArray {
            emoticons.append(Emoticon(emoticonName: str))
        }

    }
}
