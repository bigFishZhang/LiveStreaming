//
//  ChatToolsView.swift
//  LiveStream
//
//  Created by bigfish on 2019/5/15.
//  Copyright © 2019 zzb. All rights reserved.
//

import UIKit

protocol ChatToolsViewDelegate:class {
    
    func chatToolsView(toolView:ChatToolsView,message:String)
    
}

class ChatToolsView: UIView, NibLoadable{
    
    weak var delegate:ChatToolsViewDelegate?
    
    fileprivate lazy var emoticonBtn : UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
    fileprivate lazy var emoticonView : EmoticonView = EmoticonView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 250))

    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var sendMsgButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    @IBAction func textFieldDidEdit(_ sender: UITextField) {
        sendMsgButton.isEnabled = sender.text!.count != 0
    }
    
    @IBAction func sendButtonClick(_ sender: UIButton) {
        //1 get msg
        let message = inputTextField.text!
        
        //2 clear text
        inputTextField.text = ""
        sender.isEnabled = false
        
        //3 put msg to delegate
        delegate?.chatToolsView(toolView: self, message: message)
        
    }
}


extension ChatToolsView{
    
    fileprivate func setupUI(){
        // 1 init inputView rightView
        emoticonBtn.setImage(UIImage(named: "chat_btn_emoji"), for: .normal)
        emoticonBtn.setImage(UIImage(named: "chat_btn_keyboard"), for: .selected)
        emoticonBtn.addTarget(self, action: #selector(emoticonBtnClick(_:)), for: .touchUpInside)
        
        inputTextField.rightView = emoticonBtn
        inputTextField.rightViewMode = .always
        inputTextField.allowsEditingTextAttributes = true
        
        //2 set emoticonView 闭包
        emoticonView.emoticonClickCallback = {[weak self] emoticon in
            // 1判断是否是删除按钮
            if emoticon.emoticonName == "delete-n"{
                self?.inputTextField.deleteBackward()
                return
            }
            
            // 2获取光标位置
            guard let range = self?.inputTextField.selectedTextRange  else {
                return
            }
            self?.inputTextField.replace(range, withText: emoticon.emoticonName)
        }
    }
}


extension ChatToolsView{
    @objc fileprivate func emoticonBtnClick(_ btn:UIButton){
        btn.isSelected = !btn.isSelected
        
        //切换键盘
        let range = inputTextField.selectedTextRange
        inputTextField.resignFirstResponder()
        inputTextField.inputView = inputTextField.inputView == nil ? emoticonView : nil
        inputTextField.becomeFirstResponder()
        inputTextField.selectedTextRange = range

    }
    
}
