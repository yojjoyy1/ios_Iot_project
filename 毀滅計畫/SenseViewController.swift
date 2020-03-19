//
//  SenseViewController.swift
//  毀滅計畫
//
//  Created by sinyilin on 2020/3/16.
//  Copyright © 2020 sinyilin. All rights reserved.
//

import UIKit
import MBProgressHUD
import Firebase
class SenseViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var statusSwitch: UISwitch!
    
    @IBOutlet weak var textfieldR: UITextField!
    @IBOutlet weak var textfieldG: UITextField!
    @IBOutlet weak var textfieldB: UITextField!
    var restManager:RestManager!
    var hud:MBProgressHUD!
    var appdeleget:AppDelegate!
    var reference = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        restManager = RestManager()
        textfieldR.delegate = self
        textfieldR.keyboardType = .numberPad
        textfieldR.placeholder = "0~255"
        textfieldG.delegate = self
        textfieldG.keyboardType = .numberPad
        textfieldG.placeholder = "0~255"
        textfieldB.delegate = self
        textfieldB.keyboardType = .numberPad
        textfieldB.placeholder = "0~255"
        appdeleget = UIApplication.shared.delegate as? AppDelegate
        hud = MBProgressHUD(frame: CGRect(x: 0, y: 0, width: Int((self.view.frame.size.width)/5), height: Int((self.view.frame.size.width)/5)))
        hud.hide(animated: true)
        appdeleget.window?.addSubview(hud)
        reference.child("arduino/rgb").observe(.value) { (snapshot) in
            let dic = snapshot.value as! NSDictionary
            let r = dic["r"] as! Int
            let g = dic["g"] as! Int
            let b = dic["b"] as! Int
            if r == 0 && g == 0 && b == 0
            {
                self.statusSwitch.isOn = false
            }
            else
            {
                self.statusSwitch.isOn = true
            }
        }
        // Do any additional setup after loading the view.
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        textfieldR.resignFirstResponder()
        textfieldG.resignFirstResponder()
        textfieldB.resignFirstResponder()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == textfieldR
        {
            textfieldR.text = textField.text
        }
        else if textField == textfieldG
        {
            textfieldG.text = textField.text
        }
        else
        {
            textfieldB.text = textField.text
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == textfieldR
        {
            textfieldR.text = textField.text
        }
        else if textField == textfieldG
        {
            textfieldG.text = textField.text
        }
        else
        {
            textfieldB.text = textField.text
        }
    }
    @IBAction func sendRGBAction(_ sender: UIButton) {
        if checkRGBTextField()
        {
            CustomActivityView.ShowHUD(hud: self.hud, message: "")
            let dic:NSMutableDictionary = NSMutableDictionary()
            if textfieldR.text != ""
            {
                dic["r"] = Int(textfieldR.text!)
            }
            if textfieldG.text != ""
            {
                dic["g"] = Int(textfieldG.text!)
            }
            if textfieldB.text != ""
            {
                dic["b"] = Int(textfieldB.text!)
            }
            
            restManager.sendApi(api: "setRGB", body: dic) { (_) in
                CustomActivityView.HiddenHUD(hud: self.hud)
            }
        }
        
    }
    func checkRGBTextField() -> Bool
    {
        if textfieldR.text == "" && textfieldG.text == "" && textfieldB.text == ""
        {
            let alertc = UIAlertController(title: "至少一個數值", message: nil, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "確定", style: .default, handler: nil)
            alertc.addAction(alertAction)
            self.present(alertc, animated: true, completion: nil)
            return false
        }
        else
        {
            if textfieldR.text != ""
            {
                if Int(textfieldR.text!)! > 255
                {
                    let alertc = UIAlertController(title: "不可大於255", message: nil, preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "確定", style: .default, handler: nil)
                    alertc.addAction(alertAction)
                    self.present(alertc, animated: true, completion: nil)
                    return false
                }
            }
            else if textfieldG.text != ""
            {
                if Int(textfieldG.text!)! > 255
                {
                    let alertc = UIAlertController(title: "不可大於255", message: nil, preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "確定", style: .default, handler: nil)
                    alertc.addAction(alertAction)
                    self.present(alertc, animated: true, completion: nil)
                    return false
                }
            }
            else if textfieldB.text != ""
            {
                if Int(textfieldB.text!)! > 255
                {
                    let alertc = UIAlertController(title: "不可大於255", message: nil, preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "確定", style: .default, handler: nil)
                    alertc.addAction(alertAction)
                    self.present(alertc, animated: true, completion: nil)
                    return false
                }
            }
            return true
        }
    }
    @IBAction func statusSwitchAction(_ sender: UISwitch) {
        print("senser:\(sender.isOn)")
        if !sender.isOn
        {
            let dic:NSDictionary = ["r":0,"g":0,"b":0]
            restManager.sendApi(api: "setRGB", body: dic) { (_) in}
        }
        else
        {
            let dic:NSDictionary = ["r":0,"g":180,"b":0]
            restManager.sendApi(api: "setRGB", body: dic) { (_) in}
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
