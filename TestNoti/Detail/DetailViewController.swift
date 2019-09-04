//
//  DetailViewController.swift
//  TestNoti
//
//  Created by nutdanai on 8/1/2562 BE.
//  Copyright © 2562 nutdanai. All rights reserved.
//

import UIKit
import ApiAI

class DetailViewController: UIViewController {

    @IBOutlet var textField: UITextField!
    
    @IBOutlet var btnCommon: UIButton!
    
//    fileprivate var response: QueryResponse? = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onClick(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        
        let request = ApiAI.shared().textRequest()
        
        if let text = textField.text {
            request?.query = [text]
        } else {
            request?.query = [""]
        }
        
        request?.setMappedCompletionBlockSuccess({ (request, response) in
            let response = response as! AIResponse
            if response.result.action == "money" {
                if let parameters = response.result.parameters as? [String: AIResponseParameter]{
                    let amount = parameters["amout"]!.stringValue
                    let currency = parameters["currency"]!.stringValue
                    let date = parameters["date"]!.dateValue
                    
                    print("Spended \(amount) of \(currency) on \(date)")
                }
            }
        }, failure: { (request, error) in
            // TODO: handle error
        })
        
        request?.setCompletionBlockSuccess({[unowned self] (request, response) -> Void in
//            let resultNavigationController = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as! ResultNavigationController
//
//            resultNavigationController.response = response as AnyObject?
//
//            self.present(resultNavigationController, animated: true, completion: nil)
            
//            hud.hide(animated: true)
            guard let resultData = response as AnyObject? else {
                return
            }
            guard let queryResult = resultData["result"] as AnyObject? else {
                return
            }
            guard let parameter = queryResult["parameters"] as AnyObject? else {
                return
            }
            print("parameter \(parameter)")
            
//            print("response \(resultData["result"])")
            }, failure: { (request, error) -> Void in
//                hud.hide(animated: true)
        });
        
        ApiAI.shared().enqueue(request)
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
