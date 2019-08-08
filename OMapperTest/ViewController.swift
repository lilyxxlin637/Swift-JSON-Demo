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

let jsonString = "{\"name\":\"lily\",\"age\":21,\"friends\":[{\"gender\":\"G\",\"friendsName\":\"Andy\"},{\"friendsName\":\"frank\",\"gender\":\"B\"}]}"

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let user = User(JSONString: jsonString)

        let user1 = User()
        print(user1.toJSONString(prettyPrint: false))
    }
}


class User: Mappable{
    var userName: String? = "oyo"
    var userAge: Int = 3
    var friends = [Friends]()

    required init?(map: Map) {
        if map.JSON["name"] == nil{
            return nil
        }
    }
    
    init(){
        self.friends = [Friends(),Friends()]
    }

    func mapping(map: Map) {
        userName    <- map["name"]
        userAge     <- map["age"]
        friends     <- map["friends"]
    }


    func doSomethingWithString(){
//        print("name: \(self.userName)  age: \(self.userAge)")
    }
}

enum Gender{
    case male
    case female
    case unknown
}

class Friends: Mappable{
    var name: String! = "friend1"
    var gender: Gender! = .female

    required init?(map: Map) {
    }
    init(){
    }

    func mapping(map: Map) {
        name    <-  map["friendsName"]
        gender  <- (map["gender"], genderTransform)
    }

    let genderTransform = TransformOf<Gender,String>(fromJSON: { (value: String?) -> Gender in
        if let value = value {
            if value == "G"{
                return Gender.female
            }
            if value == "B"{
                return Gender.female
            }
        }
        return Gender.unknown
    }, toJSON: { (value: Gender?) -> String in
        if let value = value {
            if value == Gender.female{
                return "G"
            }
            if value == Gender.male{
                return "B"
            }
            return ""
        }
        return ""
    })
}

