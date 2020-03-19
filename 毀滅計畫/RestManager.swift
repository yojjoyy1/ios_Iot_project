//
//  RestManager.swift
//  smarthome
//
//  Created by sinyilin on 2019/10/29.
//  Copyright © 2019 sinyilin. All rights reserved.
//

import UIKit

class RestManager: NSObject {

    func sendApi(api:String,body:NSDictionary,callback:@escaping(Any)->())
    {
        let url = URL(string: "\(firebaseObject.firebaseFunctionUrl)\(api)")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        }
        catch
        {
            print("request body:\(error.localizedDescription)")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, res, err) in
            if err != nil
            {
                print("apiTopic:\(api) err:\(err!.localizedDescription) body:\(body)")
            }
            else
            {
                var res:Any!
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
//                    print("json:\(json)")
                    res = json
                }
                catch
                {
                    let str = String.init(data: data!, encoding: .utf8)
                    res = str!
//                    print("\(api) msg :\(str)")
                }
                callback(res!)
            }
        }
        task.resume()
    }
    func getApi(api:String,callback:@escaping(Any) -> ())
    {
        let url = URL(string: "\(firebaseObject.firebaseFunctionUrl)\(api)")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, res, err) in
            if err != nil
            {
                callback(err!.localizedDescription)
            }
            else
            {
                var res:Any!
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    res = json
                }
                catch
                {
                    let str = String.init(data: data!, encoding: .utf8)
                    res = str!
                }
                callback(res!)
            }
        }
        task.resume()
    }
}
