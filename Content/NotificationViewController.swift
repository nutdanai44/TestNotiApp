//
//  NotificationViewController.swift
//  Content
//
//  Created by nutdanai on 12/3/2562 BE.
//  Copyright © 2562 nutdanai. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    
    @IBOutlet var tfContent: UITextField!
    
    @IBOutlet var toosView: UIView!
    
    @IBOutlet var status: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override var inputAccessoryView: UIView?{
        return self.toosView
    }
    
    func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.body
    }
    
    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void)
    {
        //You need to handle all the actions that appear with notification
        if response.actionIdentifier == "accept"
        {
//            self.responseLabel.text = "Accepted"
//            self.responseLabel.textColor = UIColor.green
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                completion(.dismiss)
            }
        } else if response.actionIdentifier == "reject"
        {
            //If you want to use default text field - uncomment below 2 lines
            
            //let textResponse = response as! UNTextInputNotificationResponse
            //self.responseLabel.text = textResponse.userText
            
            //If you want to use default text field - comment below 2 lines
            self.becomeFirstResponder()
            self.tfContent.becomeFirstResponder()
            completion(.doNotDismiss)
        }
    }
    
    @IBAction func sendOnClick(_ sender: Any) {
        status.text = "\(tfContent.text!)"
    }
}
