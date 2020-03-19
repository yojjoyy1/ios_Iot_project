//
//  LoginViewController.swift
//  毀滅計畫
//
//  Created by sinyilin on 2020/3/16.
//  Copyright © 2020 sinyilin. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import MBProgressHUD
class LoginViewController: UIViewController,LoginButtonDelegate {

    @IBOutlet weak var facebookLoginBtn: FBLoginButton!
    var hud:MBProgressHUD!
    @IBOutlet weak var rocImageView: UIImageView!
    var appdeleget:AppDelegate!
    @IBOutlet weak var fiveManImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let bool = UserDefaults.standard.bool(forKey: "login")
        if bool
        {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let VC = storyboard.instantiateViewController(withIdentifier: "MytabbarController") as! MytabbarController
            self.present(VC, animated: true, completion: nil)
        }
    }
    //自訂方法
    func config()
    {
        appdeleget = UIApplication.shared.delegate as? AppDelegate
        facebookLoginBtn.delegate = self
        facebookLoginBtn.permissions = ["public_profile","email"]
        hud = MBProgressHUD(frame: CGRect(x: 0, y: 0, width: Int((self.view.frame.size.width)/5), height: Int((self.view.frame.size.width)/5)))
        hud.hide(animated: true)
        appdeleget.window?.addSubview(hud)
        rocImageView.backgroundColor = UIColor(red: 41/255, green: 148/255, blue: 1, alpha: 1)
        fiveManImageView.backgroundColor = UIColor(red: 41/255, green: 148/255, blue: 1, alpha: 1)
    }

    //MARK:FacebookDelegate
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error == nil
        {
            print("result:\(result)")
            if !result!.isCancelled
            {
                facebookObject.facebookAccessToken = AccessToken.current!.tokenString
                facebookObject.facebookUserId = AccessToken.current!.userID
                facebookObject.facebookCredential = FacebookAuthProvider.credential(withAccessToken: facebookObject.facebookAccessToken)
                CustomActivityView.ShowHUD(hud: self.hud, message: "")
                Auth.auth().signIn(with: facebookObject.facebookCredential) { (firebaseResult, firebaseErr) in
                    if firebaseErr != nil
                    {
                        print("firebaseErr:\(firebaseErr?.localizedDescription)")
                    }
                    else
                    {
                        Auth.auth().signIn(with: facebookObject.facebookCredential, completion: { (result, error) in
                            let user = result!.user
                            let creatDate = user.metadata.creationDate
                            let lastDate = user.metadata.lastSignInDate
                            let dateFormate = DateFormatter()
                            dateFormate.dateFormat = "YYYY/MM/dd hh:mm:ss"
                            let creatString = dateFormate.string(from: creatDate!)
                            let lastSignInString = dateFormate.string(from: lastDate!)
                            let uid = user.uid
                            UserDefaults.standard.set(true, forKey: "login")
                            UserDefaults.standard.synchronize()
                            firebaseObject.uid = uid
                            firebaseObject.creatDate = creatString
                            firebaseObject.lastSignIn = lastSignInString
                            firebaseObject.displayName = user.displayName
                            firebaseObject.email = user.email
                            firebaseObject.photoUrl = user.photoURL!.absoluteString
                            let dic:NSDictionary = ["creatDate":creatString,
                               "lastSignInDate":firebaseObject
                                .lastSignIn,
                                "email":firebaseObject.email,
                                "photoUrl":firebaseObject.photoUrl,
                                "displayName":firebaseObject.displayName]
                            Database
                                .database()
                                .reference()
                                .child("/users/\(firebaseObject.uid!)")
                                .setValue(dic)
                            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                            let VC = storyboard.instantiateViewController(withIdentifier: "MytabbarController") as! MytabbarController
                            self.present(VC, animated: true, completion: nil)
                        })
                        
                    }
                }
            }
        }
        else
        {
            print("facebook login fail:\(error?.localizedDescription)")
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("loginButtonDidLogOut 登出:\(loginButton.permissions)")
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
