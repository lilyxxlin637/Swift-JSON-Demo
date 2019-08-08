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

//name is nil
let jsonStringNil = "{\"name\":,\"age\":21,\"friends\":[{\"gender\":\"G\",\"friendsName\":\"Andy\"},{\"friendsName\":\"frank\",\"gender\":\"B\"}]}"

//age is string not an int as wished
let jsonStringInt =  "{\"name\":{\"firstname:\":\"lily\"},\"age\":\"21\",\"friends\":[{\"gender\":\"G\",\"friendsName\":\"Andy\"},{\"friendsName\":\"frank\",\"gender\":\"B\"}]}"

let playerJsonString = "{\"name\":\"lily\",\"age\":21,\"friends\":[{\"gender\":\"G\",\"friendsName\":\"Andy\"},{\"friendsName\":\"frank\",\"gender\":\"B\"}]}"

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //mappalbe
        let user = User(JSONString: jsonString) //jsonStringNil)
        print("user name: (expected lily)")
        print(user?.userName as Any)
        
        let user1 = User(JSONString: jsonStringInt)
        //if mismatch type, result in unexpected value
        print("\nuser age: (expected 21)(error demo)")
        print(user1?.userAge as Any)
        
        let user2 = User()
        print("\nJSON of user2")
        print(user2.toJSON())
        
        //immutable
        let player = try? Player(JSONString: playerJsonString)
        print("\nJSON of player")
        print(player?.toJSON() as Any)
        
        print("\nend of demo")
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
        userName    >>> map["name"]  //Demo: different structure as input json
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
    let gamerName: String = "lol"
    var age: Int?
    
    required init(map: Map) throws {
        name = (try? map.value("name")) ?? "default" //provides default value
    }
    
    func mapping(map: Map) {
        name    >>> map["name.realName"] //Demo: immutable >>>  & different structure from init
        gamerName    >>> map["name.gamerName"] //Demo: extra value in json
        age     <- map["age"]
    }
}

