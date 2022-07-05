//
//  Item.swift
//  Todoey
//
//  Created by Kittisak Panluea on 4/7/2565 BE.
//

import Foundation
import RealmSwift

class Items: Object {
    @objc dynamic var title:String = ""
    @objc dynamic var done:Bool = false
    @objc dynamic var dateCreated:Date?
    
//  fromType คือเอาง่าย ๆ ว่าจะไปเชื่อมกับข้อมูลคลาสไหน แล้วก้ property คือจะเชื่อมกับ property ตัวไหนในคลาสนั้น
    var parentCategory = LinkingObjects(fromType:Category.self , property:"items")
}
