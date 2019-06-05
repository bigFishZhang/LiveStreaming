//
//  AttrStringGenerator.swift
//  LiveStream
//
//  Created by bigfish on 2019/6/5.
//  Copyright © 2019 zzb. All rights reserved.
//

import UIKit
import Kingfisher

class AttrStringGenerator {
    //消息的富文本处理
}

extension AttrStringGenerator{
    
    /// 生成进入离开房间富文本消息
    ///
    /// - Parameters:
    ///   - username: 用户名
    ///   - isJoin: active
    /// - Returns: 富文本消息
    class func generateJoinLeaveRoomMsg(_ username:String, _ isJoin:Bool) ->NSAttributedString {
        
        let activeString = "\(username) " + (isJoin ? "进入房间" : "离开房间")
        
        let acvtiveAttrString = NSMutableAttributedString(string: activeString)
        
        acvtiveAttrString.addAttributes([NSAttributedString.Key.foregroundColor :UIColor.orange ], range: NSRange(location: 0, length: username.count))
        
        return acvtiveAttrString
    }
    
    
    /// 生成即时通讯的富文本消息
    ///
    /// - Parameters:
    ///   - username: 消息发送者名称
    ///   - message: 消息内容
    /// - Returns: 富文本消息
    class func generateTextMessage(_ username:String,_ message : String) ->NSAttributedString{
        // 1.get all string
        let chatMessage = "\(username): \(message)"
        
        // 2 generate MutableAttributedString
        let chatMsgMAttrString = NSMutableAttributedString(string: chatMessage)
        
        // 3 set color
        chatMsgMAttrString.addAttributes([NSAttributedString.Key.foregroundColor :UIColor.orange ], range: NSRange(location: 0, length: username.count))
        
        // 4 check contans emoj
        let pattern = "\\[.*?\\]"
        
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else{
            return chatMsgMAttrString
        }
        
        let results  = regx.matches(in: chatMessage, options: [], range: NSRange(location: 0, length: chatMessage.count))
        
        // 4.1 get rusult
        for i in (0..<results.count).reversed(){
            let result = results[i]
            let emotionName = (chatMessage as NSString).substring(with: result.range)
            
            // create image
            guard let image = UIImage(named: emotionName) else{ continue }
            
            // create NSTextAttachment
            let attachment = NSTextAttachment()
            attachment.image = image
            let font = UIFont.systemFont(ofSize: 15)
            attachment.bounds = CGRect(x: 0, y: -3, width: font.lineHeight, height: font.lineHeight)
            let imageAttrStr = NSAttributedString(attachment: attachment)
            
            // replace string
            chatMsgMAttrString.replaceCharacters(in: result.range, with: imageAttrStr)
        }
        
        return chatMsgMAttrString

    }
    
    
    /// 生成礼物的富文本消息
    ///
    /// - Parameters:
    ///   - username: 发礼物的人
    ///   - giftName: 礼物名称
    ///   - giftURL: 礼物图片URL
    /// - Returns: 礼物富文本消息
    class func generateGiftMessage(_ username : String,_ giftName : String,_ giftURL : String) -> NSAttributedString{
        // 1.get all string
        let giftMessage = "\(username) 赠送 \(giftName) "
        
        
        // 2 generate MutableAttributedString
        let giftMAttrString = NSMutableAttributedString(string: giftMessage)
        
        
        // 3 set username color
        giftMAttrString.addAttributes([NSAttributedString.Key.foregroundColor :UIColor.orange ], range: NSRange(location: 0, length: username.count))
        
        
        // 4 set gift name color
        let range = (giftMessage as NSString).range(of: giftName)
        giftMAttrString.addAttributes([NSAttributedString.Key.foregroundColor :UIColor.red ], range: range)
        
        // 5 add image
        guard let image = KingfisherManager.shared.cache.retrieveImageInMemoryCache(forKey: giftURL) else {
            return giftMAttrString
        }
        
        let attacment = NSTextAttachment()
        attacment.image = image
        let font = UIFont.systemFont(ofSize: 15)
        attacment.bounds = CGRect(x: 0, y: -3, width: font.lineHeight, height: font.lineHeight)
        let imageAttrStr = NSAttributedString(attachment: attacment)
        
        giftMAttrString.append(imageAttrStr)

        return giftMAttrString
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

