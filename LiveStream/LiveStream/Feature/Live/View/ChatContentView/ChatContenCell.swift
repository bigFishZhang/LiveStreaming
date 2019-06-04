//
//  ChatContenCell.swift
//  LiveStream
//
//  Created by bigfish on 2019/6/4.
//  Copyright © 2019 zzb. All rights reserved.
//

import UIKit

class ChatContenCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        contentLabel.font = UIFont.systemFont(ofSize: 15)
        contentLabel.textColor = UIColor.gray
        selectionStyle = .none
        contentView.backgroundColor = UIColor.clear
        
        
    }

}
