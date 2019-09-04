//
//  SingletonService.swift
//  TestNoti
//
//  Created by nutdanai on 2/1/2562 BE.
//  Copyright © 2562 nutdanai. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

import RxSwift

class SingletonService: NSObject {
    private override init() {}
    static let shared = SingletonService()

    var publishSubject = PublishSubject<String>()
    
//    let POST_TAG = "UPDATE_TAG"
    var status = ""
    var status2 = Variable<String>("")
    
//    func addNewStatus(_ newStatus: String?) {
//        if newStatus != nil {
//            self.status = newStatus!.trimmingCharacters(in: .whitespacesAndNewlines)
//            updateDataObserver()
//        }
//    }
//
//    func setNewStatus(_ newStatus: String?) {
//        if newStatus != nil {
//            self.status = newStatus!.trimmingCharacters(in: .whitespacesAndNewlines)
//            updateDataObserver()
//        }
//    }
//
//    func updateDataObserver() {
//        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: POST_TAG),object: nil))
//    }
}
