//
//  ViewController.swift
//  TestNoti
//
//  Created by nutdanai on 2/1/2562 BE.
//  Copyright © 2562 nutdanai. All rights reserved.
//

//import UIKit
//import co
import RealmSwift

import RxSwift
import RxCocoa

import FirebaseRemoteConfig

import SDWebImage
import UserNotifications

import FirebaseAnalytics

class ViewController: UIViewController {
    @IBOutlet var lbStatus: UILabel!
    @IBOutlet var lbBot: UILabel!
    
    @IBOutlet var tfInput: UITextField!
    
    //    var chocolates = [Chocolate]()
//    let chocolates: Variable<[Chocolate]> = Variable([])

//    var data: Results<StatusModel>? = nil
    
    let bag = DisposeBag()
    
    @IBOutlet var viewTop: UIView!
    @IBOutlet var viewBot: UIView!
    @IBOutlet var imgTheme: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initRx()
        initSharePref()
        
        Analytics.logEvent("share_image", parameters: [
            "name": "userId" as NSObject,
            "full_text": "test01" as NSObject
            ])
    }

    @IBAction func onClick(_ sender: Any) {
//        SingletonService.shared.publishSubject.onNext("User Click")
        self.navigationController?.pushViewController(DetailViewController(), animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        initTheme()
    }
    
    func initRx() {
//        view top
        _ = SingletonService.shared.publishSubject
            .subscribe(onNext:{
//            self.alert(value: $0)
            self.lbStatus.text = $0
        }).disposed(by: bag)
        SingletonService.shared.publishSubject.onNext("")
        
//        view botts
        
//        tfInput.
        tfInput.rx.text.orEmpty
            .bind(to: SingletonService.shared.publishSubject)
            .disposed(by: bag)
    }
    
    func initSharePref() {
        
        
        let preferences = UserDefaults.standard
        
        let currentLevelKey = "currentLevel"
        
        preferences.set(20, forKey: currentLevelKey)
        
        //  Save to disk
        let didSave = preferences.synchronize()
        
        if !didSave {
            //  Couldn't save (I've never seen this happen in real world testing)
        }
    }
}
extension ViewController {
    func alert (value: String) {
        let alert = UIAlertController(title: "Alert", message: "You got '\(value)'", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            //            switch action.style{
            //            case .default:
            //                print("default")
            //            case .cancel:
            //                print("cancel")
            //            case .destructive:
            //                print("destructive")
            //            }
            self.lbStatus.text = value
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
//    noti
    @IBAction func sendNotificationButtonTapped(_ sender: Any) {
        
        // find out what are the user's notification preferences
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            
            // we're only going to create and schedule a notification
            // if the user has kept notifications authorized for this app
            guard settings.authorizationStatus == .authorized else { return }
            
            // create the content and style for the local notification
            let content = UNMutableNotificationContent()
            
            // #2.1 - "Assign a value to this property that matches the identifier
            // property of one of the UNNotificationCategory objects you
            // previously registered with your app."
            content.categoryIdentifier = "CustomSamplePush"
            
            // create the notification's content to be presented
            // to the user
            content.title = "Custom!"
            content.subtitle = "Exceeded balance by $300.00."
            content.body = "One-time overdraft fee is $25. Should we cover transaction?"
            content.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: "duckSound.wav"))
            
            // #2.2 - create a "trigger condition that causes a notification
            // to be delivered after the specified amount of time elapses";
            // deliver after 10 seconds
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
            
            // create a "request to schedule a local notification, which
            // includes the content of the notification and the trigger conditions for delivery"
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
            
            // "Upon calling this method, the system begins tracking the
            // trigger conditions associated with your request. When the
            // trigger condition is met, the system delivers your notification."
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
        } // end getNotificationSettings
        
    }
    
    
    @IBAction func sendNotification2ButtonTapped(_ sender: Any) {
        
        // find out what are the user's notification preferences
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            
            // we're only going to create and schedule a notification
            // if the user has kept notifications authorized for this app
            guard settings.authorizationStatus == .authorized else { return }
            
            // create the content and style for the local notification
            let content = UNMutableNotificationContent()
            
            // #2.1 - "Assign a value to this property that matches the identifier
            // property of one of the UNNotificationCategory objects you
            // previously registered with your app."
//            content.categoryIdentifier = "x"
            
            // create the notification's content to be presented
            // to the user
            content.title = "Normal Case!"
            content.subtitle = "Exceeded balance by $300.00."
            content.body = "One-time overdraft fee is $25. Should we cover transaction?"
            content.sound = UNNotificationSound.default
            
            // #2.2 - create a "trigger condition that causes a notification
            // to be delivered after the specified amount of time elapses";
            // deliver after 10 seconds
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
            
            // create a "request to schedule a local notification, which
            // includes the content of the notification and the trigger conditions for delivery"
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
            
            // "Upon calling this method, the system begins tracking the
            // trigger conditions associated with your request. When the
            // trigger condition is met, the system delivers your notification."
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
        } // end getNotificationSettings
        
    }
}
