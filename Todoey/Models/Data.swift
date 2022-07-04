//
//  Data.swift
//  Todoey
//
//  Created by Kittisak Panluea on 4/7/2565 BE.
//

import Foundation
import RealmSwift

class Data:Object {
//    dynamic ทำให้สมมติว่าเราเปลี่ยนชื่อในขณะที่แอปกำลังทำงานอยู่ มันจะทำให้การอัปเดตค่าอัตโนมัติไปยังฐานข้อมูล
//    แต่ว่าตัว dynamic มันจะใช้คู่กับ objective-c api ดังนั้นเวลาใช้งานจึงต้องมีการเพิ่ม @objc ไว้หน้า dynamic
    dynamic var name:String = ""
    dynamic var age:Int = 0
}
