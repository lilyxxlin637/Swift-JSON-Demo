//
//  ViewController.swift
//  OMapperTest
//
//  Created by lily on 2019/7/24.
//  Copyright © 2019 oyo. All rights reserved.
//

import UIKit
import ObjectMapper

//import HandyJSON


class ViewController: UIViewController {
    let user = User()

    override func viewDidLoad() {
        super.viewDidLoad()
        let json = user.toJSON()
        print(json)
        
        let string : [String : Any?] = ["name": "lily", "age": nil]
        let specialUser = SpecialUser(JSON: string)
        specialUser?.printInfo()
//        let user = User(JSON: string)
//        user?.printInfo()
//        print("~~~~~~~~~~~")
//        print(user?.toJSON())
    }
}


class User: Mappable{
    var name: String?
    var ageID: Int = 3
    
    let stringTransform = TransformOf<String,String>(fromJSON: { (value: String?) -> String in
        if let value = value {
            return String(value)
        }
        return ""
    }, toJSON: { (value: String?) -> String in
        if let value = value {return String(value)}
        return ""
    })
    
    init(){
        ageID = 4
        name = "oyo"
    }
    
    required init?(map: Map) {
        //
    }
    
    func mapping(map: Map) {
        name    <- (map["name"], stringTransform)
        ageID   <- map["age"]
    }
    
    func printInfo(){
        print(ageID)
        print(name)
    }
    
    func doSomethingWithString(){
//        print(self.name + self.id)
    }
}

class SpecialUser: User{
    
}

