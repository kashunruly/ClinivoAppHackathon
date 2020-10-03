//
//  DoctorChatTableViewCell.swift
//  Clinivo
//
//  Created by Kashlon Palmer on 5/29/20.
//  Copyright © 2020 Kashlon Palmer. All rights reserved.
//

import UIKit

class DoctorChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var messageText: UILabel!
    
    @IBOutlet weak var rightBubble: UIView!
    
    @IBOutlet weak var leftBubble: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        if let _ = rightBubble{
            rightBubble.layer.cornerRadius = 10
            rightBubble.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner]
            
        }

        if let _ = leftBubble{
            leftBubble.layer.cornerRadius = 10
            leftBubble.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMinYCorner,.layerMaxXMinYCorner]
        }
        
        self.backgroundColor = .clear
    }

   

}
