//
//  StatusModel.swift
//  TestNoti
//
//  Created by nutdanai on 2/1/2562 BE.
//  Copyright © 2562 nutdanai. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class StatusModel: Object, Mappable {
    
    @objc dynamic var status = ""
    @objc dynamic var idFocus = ""
    
    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        status              <- map["status"]
        idFocus              <- map["idFocus"]
    }
}

class Chocolate: Object, Mappable {
    
    @objc dynamic var tase = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        tase              <- map["tase"]
    }
}
