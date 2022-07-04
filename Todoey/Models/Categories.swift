//
//  Categories.swift
//  Todoey
//
//  Created by Kittisak Panluea on 4/7/2565 BE.
//

import Foundation
import RealmSwift

class Category: Object {
    @Persisted var name:String = ""
    
//    สร้างความสัมพันธ์ของข้อมูลกับตัว Items ล่ะนะ
    let items = List<Items>()
}
