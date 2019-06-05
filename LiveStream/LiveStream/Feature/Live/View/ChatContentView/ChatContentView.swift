//
//  ChatContentView.swift
//  LiveStream
//
//  Created by bigfish on 2019/6/4.
//  Copyright © 2019 zzb. All rights reserved.
//

import UIKit

private let kChatContentCell = "kChatContentCell"

class ChatContentView: UIView,NibLoadable {

    @IBOutlet weak var chatTableView: UITableView!
    
    //save msg
    fileprivate lazy var messages : [NSAttributedString] = [NSAttributedString]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        chatTableView.register(UINib(nibName: "ChatContenCell", bundle: nil), forCellReuseIdentifier: kChatContentCell)
        chatTableView.backgroundColor = UIColor.clear
        chatTableView.separatorStyle = .none
        
        chatTableView.estimatedRowHeight = 40
        
    }
    
    func insertMsg(_ msg:NSAttributedString)  {
        messages.append(msg)
        chatTableView.reloadData()
        
        let indexPath = IndexPath(row: messages.count - 1 , section: 0)
        chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        
        
    }

}


extension ChatContentView: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kChatContentCell, for: indexPath) as! ChatContenCell
        cell.contentLabel.attributedText = messages[indexPath.row]
        return cell
        
    }
    

    
}

