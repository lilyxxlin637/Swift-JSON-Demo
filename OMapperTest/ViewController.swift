//
//  ViewController.swift
//  OMapperTest
//
//  Created by lily on 2019/7/24.
//  Copyright © 2019 oyo. All rights reserved.
//

import UIKit
import ObjectMapper

let jsonString = "{\"name\":{\"firstname:\":\"lily\"},\"age\":21,\"friends\":[{\"gender\":\"G\",\"friendsName\":\"Andy\"},{\"friendsName\":\"frank\",\"gender\":\"B\"}]}"

let jsonStringNil = "{\"name\":,\"age\":21,\"friends\":[{\"gender\":\"G\",\"friendsName\":\"Andy\"},{\"friendsName\":\"frank\",\"gender\":\"B\"}]}"

let playerJsonString = "{\"name\":\"lily\",\"age\":21,\"friends\":[{\"gender\":\"G\",\"friendsName\":\"Andy\"},{\"friendsName\":\"frank\",\"gender\":\"B\"}]}"

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let user = User(JSONString: jsonString) //jsonStringNil)
        
        print(user?.userName as Any)
        
        let user1 = User()
        print(user1.toJSON())
        
        let player = try? Player(JSONString: playerJsonString)
        print(player?.toJSON() as Any)
        
        print("end of demo")
    }
}

class User: Mappable{
    var userName: String? = "lily"
    var userAge: Int = 3
    var friends = [Friends]()

    required init?(map: Map) {
        //Demo: filter
        if map.JSON["name"] == nil{
            return nil
        }
    }
    
    init(){
        self.friends = [Friends(),Friends()]
    }

    func mapping(map: Map) {
        userName    <- map["name.firstname"] //Demo: nested objects
        userAge     <- map["age"]
        friends     <- map["friends"]
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

    //Demo: Custom Transform
    let genderTransform = TransformOf<Gender,String>(fromJSON: { (value: String?) -> Gender in
        if let value = value {
            switch value {
            case "G":
                return Gender.female
            case "B":
                return Gender.male
            default:
                return Gender.unknown
            }
        }
        return Gender.unknown
    }, toJSON: { (value: Gender?) -> String in
        if let value = value {
            switch value {
            case .female:
                 return "G"
            case .male:
                return "B"
            default:
                return ""
            }
        }
        return ""
    })
}

class Player: ImmutableMappable{
    let name: String
    var age: Int?
    
    required init(map: Map) throws {
        name = (try? map.value("name")) ?? "default" //provides default value
    }
    
    func mapping(map: Map) {
        name    >>> map["name.firstname"] //Demo: immutable
        age     <- map["age"]
    }
}

