//
//  ViewController.swift
//  毀滅計畫
//
//  Created by sinyilin on 2020/3/16.
//  Copyright © 2020 sinyilin. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD
import MarqueeLabel
class HomeViewController: UIViewController {

    @IBOutlet weak var maskImageView: UIImageView!
    @IBOutlet weak var faceImageView: UIImageView!
    var hud:MBProgressHUD!
    var appdeleget:AppDelegate!
    var restManager:RestManager!
    var reference = Database.database().reference()
    var rightButton:UIButton!
    @IBOutlet weak var rLabel: UILabel!
    @IBOutlet weak var gLabel: UILabel!
    @IBOutlet weak var bLabel: UILabel!
    @IBOutlet weak var ledImageView: UIImageView!
    @IBOutlet weak var goLabel: UILabel!
    var mySec = 0
    var imagePage = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }

    func config()
    {
        self.rLabel.text = "0"
        self.gLabel.text = "0"
        self.bLabel.text = "0"
        appdeleget = UIApplication.shared.delegate as? AppDelegate
        hud = MBProgressHUD(frame: CGRect(x: 0, y: 0, width: Int((self.view.frame.size.width)/5), height: Int((self.view.frame.size.width)/5)))
        hud.hide(animated: true)
        appdeleget.window?.addSubview(hud)
        restManager = RestManager()
        ledImageView.image = UIImage(named: "led")
        goLabel.textColor = UIColor.red
        maskImageView.alpha = 0
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.goLabel.frame.origin.x = -self.view.frame.size.width
        var images = [UIImage]()
        images.append(UIImage(named: "sad")!)
        images.append(UIImage(named: "happy")!)
        faceImageView.animationImages = images
        faceImageView.animationDuration = 4
        faceImageView.animationRepeatCount = 0
        faceImageView.image = images.last
        faceImageView.startAnimating()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        maskImageView.frame = CGRect(x: 0, y: self.faceImageView.center.y - 20, width: self.faceImageView.frame.size.width, height: self.faceImageView.frame.size.height * 0.5)
        maskImageView.center.x = self.faceImageView.center.x
        print("x:\(self.goLabel.frame.origin.x)")
        let opts: UIView.AnimationOptions = [.transitionFlipFromLeft , .repeat]
        ledImageView.image = ledImageView.image?.withRenderingMode(.alwaysTemplate)
        reference.child("arduino/rgb").observe(.value) {
            (snapshot) in
            let snaspshotDic = snapshot.value as! NSDictionary
            let rValue = snaspshotDic["r"] as! Int
            let gValue = snaspshotDic["g"] as! Int
            let bValue = snaspshotDic["b"] as! Int
            self.rLabel.text = "\(rValue)"
            self.gLabel.text = "\(gValue)"
            self.bLabel.text = "\(bValue)"
            print("rValue:\(rValue),gValue:\(gValue),bValue:\(bValue)")
            if rValue == 0 && gValue == 0 && bValue == 0
            {
                self.ledImageView.tintColor = UIColor.black
            }
            else
            {
                let rgbColor = UIColor(red: CGFloat(rValue), green: CGFloat(gValue), blue: CGFloat(bValue), alpha: 1)
                self.ledImageView.tintColor = rgbColor
            }
        }
        reference.child("notification").observe(.value) { (snapshot) in
            let dic = snapshot.value as! NSDictionary
            let str = dic["msg"] as! String
            let sec = dic["sec"] as! Int
            DispatchQueue.main.async {
                self.goLabel.text = str
                self.mySec = sec
                self.goLabel.layer.removeAllAnimations()
                UIView.animate(withDuration: TimeInterval(self.mySec), delay: 0, options: opts, animations: {
                    self.goLabel.frame.origin.x += self.view.frame.size.width
                }, completion: {(_) in
                    self.goLabel.frame.origin.x = -self.view.frame.size.width
                })
            }
        }
       
        UIView.animate(withDuration: 4.0, delay: 0, options: UIView.AnimationOptions.repeat, animations: {
            self.maskImageView.alpha = 1
        }) { (_) in
            self.maskImageView.alpha = 0
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.goLabel.frame.origin.x = -self.view.frame.size.width
    }
}

