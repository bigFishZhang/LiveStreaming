//
//  RoomViewController.swift
//  LiveStream
//
//  Created by zzb on 2019/5/3.
//  Copyright © 2019 zzb. All rights reserved.
//

import UIKit
import Kingfisher


private let kChatToolsViewHeight : CGFloat = 44

private let kGiftlistViewHeight : CGFloat = SCREEN_HEIGHT * 0.5

private let kChatContentViewHeight : CGFloat = 200

class RoomViewController: UIViewController,EmitterHandle {
    // MARK: 控件属性
    @IBOutlet weak var bgImageView: UIImageView!
    
    fileprivate lazy var chatToolsView : ChatToolsView = ChatToolsView.loadFromNib()
    fileprivate lazy var giftListView : GiftListView = GiftListView.loadFromNib()
    fileprivate lazy var chatContentView : ChatContentView = ChatContentView.loadFromNib()
    
    fileprivate lazy var socket : ZBSocket = ZBSocket(addr: "172.18.220.109", port: 7999)
    fileprivate var heartBeatTimer : Timer?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //1 设置UI界面 
        setupUI()
        //2 监听键盘通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name:UIResponder.keyboardWillChangeFrameNotification, object: nil)
        //3 连接聊天服务器
        connectServer()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //离开房间
        socket.sendLeaveRoom()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        heartBeatTimer?.invalidate()
        heartBeatTimer = nil
    }


}
// MARK:- 设置UI界面内容
extension RoomViewController {
    fileprivate func setupUI() {
        setupBlurView()
        setupBottomView()
    }
    
    fileprivate func setupBlurView() {
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        blurView.frame = bgImageView.bounds
        bgImageView.addSubview(blurView)
    }
    
    fileprivate func setupBottomView() {
        // 0.设置聊天内容界面
        chatContentView.frame = CGRect(x: 0, y: view.bounds.height - kChatToolsViewHeight - kChatContentViewHeight , width: view.bounds.width, height: kChatContentViewHeight)
        chatContentView.autoresizingMask = [.flexibleWidth,.flexibleTopMargin]
        view.addSubview(chatContentView)
        
        
        // 1.设置chatToolsView
        chatToolsView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: kChatToolsViewHeight)
        chatToolsView.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        chatToolsView.delegate = self
        view.addSubview(chatToolsView)
        // 2.设置giftListView
        giftListView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: kGiftlistViewHeight)
        giftListView.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        view.addSubview(giftListView)
        giftListView.delegate = self
        
        
        
        
    }
}


// MARK:- 事件监听
extension RoomViewController {
    @IBAction func exitBtnClick() {
        _ = navigationController?.popViewController(animated: true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        chatToolsView.inputTextField.resignFirstResponder()
        
        //隐藏礼物
        UIView.animate(withDuration: 0.25) {
            self.giftListView.frame.origin.y = SCREEN_HEIGHT
        }
        
    }
    
    
    @IBAction func bottomMenuClick(_ sender: UIButton) {
        switch sender.tag {
        case 10:
            print("点击了聊天")
            chatToolsView.inputTextField.becomeFirstResponder()
        case 11:
            print("点击了分享")
        case 12:
            print("点击了礼物")
            UIView.animate(withDuration: 0.25) {
                self.giftListView.frame.origin.y  =  SCREEN_HEIGHT - kGiftlistViewHeight
            }
        case 13:
            print("点击了更多")
        case 14:
            sender.isSelected = !sender.isSelected
            let point = CGPoint(x: sender.center.x, y: view.bounds.height - sender.bounds.height * 0.5)
            sender.isSelected ? startEmitter(point) : stopEmitter()
//            print("点击了粒子")
        default:
            fatalError("未处理按钮")
        }
    }
}

// MARK:- 监听键盘的弹出
extension RoomViewController {
    @objc fileprivate func keyboardWillChangeFrame(_ note : Notification){
        let duration = note.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let endFrame = (note.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let inputViewY = endFrame.origin.y - kChatToolsViewHeight

        UIView.animate(withDuration: duration, animations: {
            UIView.setAnimationCurve(UIView.AnimationCurve(rawValue: 7)!)
            let endY = inputViewY == (SCREEN_HEIGHT - kChatToolsViewHeight) ? SCREEN_HEIGHT : inputViewY
            self.chatToolsView.frame.origin.y = endY
            
            let contentEndY = inputViewY == (SCREEN_HEIGHT - kChatToolsViewHeight) ? (SCREEN_HEIGHT - kChatToolsViewHeight - kChatContentViewHeight) : endY - kChatContentViewHeight
            
            self.chatContentView.frame.origin.y = contentEndY
            
        })
    }
    
    
}
// MARK:- 监听用户输入的内容
extension RoomViewController : ChatToolsViewDelegate ,GiftListViewDelegate{
    func chatToolsView(toolView: ChatToolsView, message: String) {
        print(message)
        socket.sendTextMsg(message)
    }
    
    func giftListView(giftView: GiftListView, giftModel: GiftModel) {
        print(giftModel.subject)
        socket.sendGiftMsg(giftModel.subject, giftModel.img2, 1)
    }
    
    
    
    
}

// MARK: -给聊天服务器发送消息
extension RoomViewController {
    fileprivate func connectServer(){
        if socket.connectServer(){
            print("聊天服务器连接成功")
            //成为代理
            socket.delegate = self
            
            //开始接收消息
            socket.startReadMsg()
            
            //开始发送心跳包
            addHeartBeatTimer()
            
            //加入房间
            socket.sendJoinRoom()
            
        }
    }
    
    
    fileprivate func addHeartBeatTimer(){
        heartBeatTimer = Timer(fireAt: Date(),
                               interval: 9,
                               target: self,
                               selector: #selector(sendHeartBeat),
                               userInfo: nil, repeats: true)
        RunLoop.main.add(heartBeatTimer!, forMode: .common)
        
    }
    @objc fileprivate func sendHeartBeat(){
        socket.sendHeartBeat()
    }

}

extension RoomViewController:ZBSocketDelegate{
    func socket(_ socket: ZBSocket, chatMsg: ChatMessage) {
        print("\(chatMsg.user.name ?? "") send msg: \(chatMsg.text!)")
        chatContentView.insertMsg(AttrStringGenerator.generateTextMessage(chatMsg.user.name, chatMsg.text))
       
        
    }
    
    func socket(_ socket: ZBSocket, giftMsg: GiftMessage) {
        
        print("\(giftMsg.user.name ?? "") send gift: \(giftMsg.giftname ?? "") url: \(giftMsg.giftUrl ?? "") ")
        
       chatContentView.insertMsg(AttrStringGenerator.generateGiftMessage(giftMsg.user.name, giftMsg.giftname, giftMsg.giftUrl))
    }
    
    func socket(_ socket: ZBSocket, joinRoom user: UserInfo) {
        print("\(user.name ?? "") 进入房间")
        chatContentView.insertMsg(AttrStringGenerator.generateJoinLeaveRoomMsg(user.name, true))
        //  chatContentView.insertMsg("\(user.name ?? "") 进入房间" )
    }
    
    func socket(_ socket: ZBSocket, leaveRoom user: UserInfo) {
        print("\(user.name ?? "") 离开房间")
        chatContentView.insertMsg(AttrStringGenerator.generateJoinLeaveRoomMsg(user.name, false))
        //chatContentView.insertMsg("\(user.name ?? "") 离开房间" )
    }
}
