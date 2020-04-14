//
//  ViewController.swift
//  PocAll
//
//  Created by nutdanai on 23/3/2563 BE.
//  Copyright © 2563 nutdanai. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    @IBOutlet var lbLog: UILabel!
    
    var wkWebView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onClick(_ sender: Any) {
        goLoginAppleWithWebView()
    }
 
    func callService(path: String, params: Dictionary<String, String>, completion: @escaping((Dictionary<String, AnyObject>?) -> Void) ) {
        var request = URLRequest(url: URL(string: path)!)
        request.httpMethod = "GET"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
//                print(json)
                completion(json)
            } catch {
//                print("error")
                completion(nil)
            }
        })
        task.resume()
    }
    func loadWebView(path: String) {
        let request = URLRequest(url : URL(string: path)!)
        wkWebView = WKWebView(frame: CGRect(x: 20, y: 20, width: 300, height: 500))
        wkWebView.frame.origin.y = 0
        wkWebView.load(request)
//        wkWebView.navigationDelegate = self
        self.view.addSubview(wkWebView)
//        self.view.sendSubview(toBack: wkWebView)
        
//        wkWebView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
    }
}

extension ViewController {
    func goLoginApple() {
        let path = "https://appleid.apple.com/auth/authorize?client_id=com.bk.PocAll&redirect_uri=pocAll://&response_type=token&scope=name%20email"
//        let params = ["username":"john", "password":"123456"] as Dictionary<String, String>
        let params = ["":""]
        callService(path: path, params: params) { (result) in
//            if result != nil {
//
//            }
            print(result)
//            self.lbLog.text = result?.description
        }
    }
    
    func goLoginAppleWithWebView() {
        loadWebView(path: "https://appleid.apple.com/auth/authorize?client_id=com.bk.PocAll&redirect_uri=sss&response_type=code+id_token&scope=name%20email&response_mode=form_post")
    }
}
