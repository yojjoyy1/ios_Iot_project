//
//  CustomActivityView.swift
//  毀滅計畫
//
//  Created by sinyilin on 2020/3/16.
//  Copyright © 2020 sinyilin. All rights reserved.
//

import UIKit
import MBProgressHUD
class CustomActivityView: NSObject {
    public static func ShowHUD(hud:MBProgressHUD,message:String)
    {
        DispatchQueue.main.async {
            hud.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            hud.center = hud.center
            hud.detailsLabel.text = message
            hud.isHidden = false
            hud.show(animated: true)
        }
    }
    public static func HiddenHUD(hud:MBProgressHUD)
    {
        DispatchQueue.main.async {
            hud.backgroundColor = nil
            hud.hide(animated: true)
        }
    }
}
