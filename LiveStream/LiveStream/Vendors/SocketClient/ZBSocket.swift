//
//  ZBSocket.swift
//  SocketClient
//
//  Created by bigfish on 2019/5/20.
//  Copyright © 2019 zzb. All rights reserved.
//

import UIKit

enum MessageType : Int {
    case join  = 0
    case leave = 1
    case text  = 2
    case gift  = 3
    case heartBeat = 100
}

//protocol ZBSocketDelegate:class {
//    func socket(_ socket : ZBSocket ,joinRoom user : UserInfo)
//    func socket(_ socket : ZBSocket ,leaveRoom user : UserInfo)
//    func socket(_ socket : ZBSocket ,chatMsg : ChatMessage)
//    func socket(_ socket : ZBSocket ,giftMsg : ChatMessage)
//}


class ZBSocket: NSObject {
   // weak var delegate : ZBSocketDelegate?
    fileprivate  var tcpClient : TCPClient
    fileprivate  lazy var userInfo : UserInfo.Builder = {
        let userInfo = UserInfo.Builder()
        userInfo.name = "zzb\(arc4random_uniform(10))"
        userInfo.level = Int32(arc4random_uniform(20))
        userInfo.iconUrl = "icon\(arc4random_uniform(2))"
        return userInfo
    }()
    
    
    
    init(addr: String, port: Int){
       tcpClient = TCPClient(addr: addr, port: port)
    }
}

extension ZBSocket {
    @discardableResult
    func connectServer() -> Bool {
        return tcpClient.connect(timeout: 5).0
    }
}

extension ZBSocket {
    @discardableResult
    func sendMsg(type : Int, msgData : Data) -> Bool {
        
        // 1.长度data
        var length = msgData.count
        let lengthData = Data(bytes: &length, count: 4)
        
        // 2.类型data
        var type = type
        let typeData = Data(bytes: &type, count: 2)
        
        // 3.拼接所有的data,并且发送消息
        let totalData = lengthData + typeData + msgData
        
        return tcpClient.send(data: totalData).0
    }
}

extension ZBSocket {
    func startReadMsg()  {
        DispatchQueue.global().async {
            while true {
                guard let lMsg = self.tcpClient.read(4) else{
                    continue
                }
                // 1 读取数据长度
                let headData = Data(bytes: lMsg, count: 4)
                var length : Int = 0
                (headData as NSData).getBytes(&length, length: 4)
                
                // 2 读取类型
                guard let typeMsg = self.tcpClient.read(2) else {
                    print("read type failed!")
                    return;
                }
                let typeData = Data(bytes: typeMsg, count: 2)
                var type : Int = 0
                (typeData as NSData).getBytes(&type, length: 2)
                print(type)
                
                // 3 读取消息
                guard let msg = self.tcpClient.read(length) else {
                    print("read msg failed!")
                    return;
                }
                let msgData = Data(bytes: msg, count: length)
                
                DispatchQueue.main.async {
                    self.handleMsg(type, msgData: msgData);
                }
                
            }
        }
    }
    
    fileprivate func handleMsg(_ type:Int, msgData:Data){
        switch type {
        case 0,1:
            let user = try! UserInfo.parseFrom(data: msgData)
            print("type\(type)",user.name, user.level, user.iconUrl)
        
        case 2:
            let chatMsg = try! ChatMessage.parseFrom(data: msgData)
            print("type\(type)",chatMsg.text)
            print("type\(type)",chatMsg.user.name, chatMsg.user.level, chatMsg.user.iconUrl)
        case 3:
            let giftMsg = try! GiftMessage.parseFrom(data: msgData)
            print("type\(type)",giftMsg.giftUrl, giftMsg.giftname, giftMsg.giftcount)
            print("type\(type)",giftMsg.user.name, giftMsg.user.level, giftMsg.user.iconUrl)
        default:
            print("其他消息类型")
        }

        
    }
    
    
    
}

extension ZBSocket {
    
    func sendHeartBeat()  {
        let heartString = "heartString"
        
        let heartData = heartString.data(using: .utf8)!
        
        sendMsg(type: 100, msgData: heartData)
    }
    
    
    func sendJoinRoom()  {
        // 1.获取长度
        let data = (try! userInfo.build()).data()
        
        // 2.发送消息
        sendMsg(type: 0, msgData: data)
            
        
    }
    
    func sendLeaveRoom()  {
        // 1.获取长度
        let data = (try! userInfo.build()).data()
        
        // 2.发送消息
         sendMsg(type: 1, msgData: data)
            
        
    }
    func sendTextMsg(_ text : String) {
        // 1.创建聊天的对象
        let chatMsg = ChatMessage.Builder()
        chatMsg.text = text
        chatMsg.user = try! userInfo.build()
        
        // 2.转成data类型
        let chatData = (try! chatMsg.build()).data()
        
        // 3.发送消息
        sendMsg(type: 2, msgData: chatData)
    }
    
    func sendGiftMsg(_ giftname : String, _ giftURL : String, _ giftcount : Int) {
        // 1.创建礼物的对象
        let giftMsg = GiftMessage.Builder()
        giftMsg.giftname = giftname
        giftMsg.giftUrl = giftURL
        giftMsg.giftcount = Int32(giftcount)
        giftMsg.user = try! userInfo.build()
        
        // 2.转成data类型
        let giftData = (try! giftMsg.build()).data()
        
        // 3.发送消息
        sendMsg(type: 3, msgData: giftData)
    }
}
