//
//  InfoTableViewCell.swift
//  毀滅計畫
//
//  Created by sinyilin on 2020/3/18.
//  Copyright © 2020 sinyilin. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
class InfoTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var des: UILabel!
    var showLogout = false
    @IBOutlet weak var logoutButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func initObject(showLogout:Bool,titleStr:String,desStr:String)
    {
        title.text = titleStr
        des.text = desStr
        logoutButton.layer.cornerRadius = logoutButton.frame.size.height / 2
        logoutButton.layer.masksToBounds = true
        if showLogout
        {
            logoutButton.isHidden = false
            title.isHidden = true
            des.isHidden = true
        }
        else
        {
            logoutButton.isHidden = true
            title.isHidden = false
            des.isHidden = false
        }
    }
    @IBAction func logout(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name("logout"), object: nil)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
