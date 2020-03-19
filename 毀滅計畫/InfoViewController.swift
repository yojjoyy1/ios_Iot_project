//
//  InfoViewController.swift
//  毀滅計畫
//
//  Created by sinyilin on 2020/3/16.
//  Copyright © 2020 sinyilin. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD
import FBSDKCoreKit
import FBSDKLoginKit
class InfoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    

    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var infoTableView: UITableView!
    var hud:MBProgressHUD!
    var appdeleget:AppDelegate!
    var restManager:RestManager!
    var reference = Database.database().reference()
    @IBOutlet weak var pictureBottomView: UIView!
    var titleArray = ["姓名:","信箱:","創辦帳號時間:","最後登入時間:"]
    var infoArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(logout(notification:)), name: Notification.Name(rawValue: "logout"), object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    //自訂方法
    func config()
    {
        self.automaticallyAdjustsScrollViewInsets = false
        self.pictureImageView.frame = CGRect(x: 0, y: 0, width: self.pictureBottomView.frame.size.height - 10, height: self.pictureBottomView.frame.size.height - 10)
        self.pictureImageView.center.x = self.view.center.x
        self.pictureImageView.layer.cornerRadius = (self.pictureImageView.frame.size.height / 2)
        self.pictureImageView.layer.masksToBounds = true
        appdeleget = UIApplication.shared.delegate as? AppDelegate
        hud = MBProgressHUD(frame: CGRect(x: 0, y: 0, width: Int((self.view.frame.size.width)/5), height: Int((self.view.frame.size.width)/5)))
        hud.hide(animated: true)
        appdeleget.window?.addSubview(hud)
        restManager = RestManager()
        firebaseObject.uid = Auth.auth().currentUser!.uid
        infoTableView.delegate = self
        infoTableView.dataSource = self
        CustomActivityView.ShowHUD(hud: self.hud, message: "")
        reference.child("users/\(firebaseObject.uid!)").observeSingleEvent(of: .value) { (snapshot) in
            if let dic = snapshot.value as? NSDictionary
            {
                firebaseObject.creatDate = dic["creatDate"] as? String
                firebaseObject.lastSignIn = dic["lastSignInDate"] as? String
                firebaseObject.displayName = dic["displayName"] as? String
                firebaseObject.photoUrl = dic["photoUrl"] as? String
                firebaseObject.email = dic["email"] as? String
                self.infoArray.append(firebaseObject.displayName)
                self.infoArray.append(firebaseObject.email)
                self.infoArray.append(firebaseObject.creatDate)
                self.infoArray.append(firebaseObject.lastSignIn)
                self.setimage()
                DispatchQueue.main.async {
                    CustomActivityView.HiddenHUD(hud: self.hud)
                }
                self.infoTableView.reloadData()
            }
        }
    }
    func setimage()
    {
        let url = URL(string: firebaseObject.photoUrl!)
        let data = NSData(contentsOf: url!)
        self.pictureImageView.image = UIImage(data: data! as Data)
    }
    @objc func logout(notification:Notification)
    {
        let alertc = UIAlertController(title: "是否登出", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "確定", style: .default) { (ok) in
            LoginManager().logOut()
            do
            {
                try Auth.auth().signOut()
                UserDefaults.standard.set(false, forKey: "login")
                UserDefaults.standard.synchronize()
                
            }
            catch
            {
                
            }
            let story = UIStoryboard.init(name: "Main", bundle: nil)
            let VC = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.present(VC, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertc.addAction(alertAction)
        alertc.addAction(cancelAction)
        self.present(alertc, animated: true, completion: nil)
    }
    //MARK:UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.infoArray.count + 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.infoTableView.frame.size.height * 0.2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoTableViewCell", for: indexPath) as! InfoTableViewCell
        if indexPath.row != infoArray.count
        {
            cell.initObject(showLogout: false, titleStr: titleArray[indexPath.row], desStr: infoArray[indexPath.row])
        }
        else
        {
            cell.initObject(showLogout: true, titleStr: "", desStr: "")
        }
        return cell
    }
}
