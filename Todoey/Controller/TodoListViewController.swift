//
//  ViewController.swift
//  Todoey
//
//  Created by Kittisak Panluea on 30/6/2565 BE.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Items]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //            แต่ก่อนจะเรียกใช้จาก CoreData อย่าลืมว่าเราต้องมีตัว context ก่อน ดังนั้นเราจะสร้าง context ขึ้นมาก่อน
    //            UIApplication.shared.delegate คือเราใช้ตัว UIApplication นั่นแหละแล้วก้เข้าถึงข้อมูลที่มัน shared กันใน UIApplication แล้วก้เข้าถึงตัว delegate แล้วทำการเปลี่ยน type ของมันเป็น AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        * ต่อไปเราจะมาดึงข้อมูลจาก FileManagerกัน
//        loadItems()
        
    }
    
    
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //        คือปัญหามันก็มีมาอีกคือด้วยความที่เราใช้ reuse ดังนั้นมันทำให้เวลาเราเลื่อนจนหมดตารางในหน้าแรกแล้วใช่ป่ะ
        //        มันก็จะเอาตารางจากช่องที่ 1 ด้านบนสุดที่เราเลื่อนผ่านมาแล้วอะ เอากลับมาใช้ใหม่ในตารางในหน้าจอล่าง
        //        ทำให้เวลาที่เราเช็คว่าเราทำส่ิงนี้สิ่ิงนั้นไปแล้ว ทำไมมันถึงมาเช็คถูกให้กับตัวหน้าจอที่สองด้วย เพราะมันเอาช่องแรกของตารางบนมาไง
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        * โค้ดข้างบนมันเยอะไปขอย่อสั้นๆแบบนี้ละกัน
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        //        แบบว่าปกติมันถ้าเราไปกดที่ row แล้วมันก็จะทำให้สีช่องมันเป็นสีเทาค้างไปเลย
        //        แต่ถ้าเราใช้อันนี้มันจะทำให้สีตารางเวลาเรากดมันจะเป็น animation fade สีเทาหายไปปิ๊บๆอะ
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    //MARK: - Add New Items
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        
        //      สร้างตัวแปรมาเก็บค่าที่ป้อนจาก TextField
        var textField = UITextField()
        
        //        ทำให้มันเป็น alert เวลากดเพิ่ม list ใหม่น่ะนะ
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        //        เพิ่มปุ่มบน alert
        alert.addAction(UIAlertAction(title: "Add Item", style: .default, handler: { action in
            //            ** แก้ข้างล่างนี้จากที่ใช้ Model Item จาก swift เราก็จะเปลี่ยนเป็น Items จาก CoreData แทน
            //            let newItem = Item()

            //            แล้วก็เรียกใช้ CoreData
            let newItem = Items(context: self.context)
            
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            
            self.saveItems()
            
        }))
        
        //        เพิ่ม textfield เข้าไปใน alert
        alert.addTextField { alertTextfield in
            //            เพิ่ม placeholder ใน textfield
            alertTextfield.placeholder = "Create new item"
            //            ทีนี้ปัญหาคือ ปุ่มกับตัว action add item มันยุคนละที่กัน เราจะทำยังไงให้มันคุยกันได้ งั้นเราก็จะสร้าง ตัวแปรมาเก็บไว้ยังไงล่ะที่ var textField
            textField = alertTextfield
        }
        
        //        เอา alert ไปแสดงผล
        present(alert, animated: true , completion: nil)
    }
    
    //MARK: - Save Data To File
    
    func saveItems() {
        do {
//            ก็ save ข้อมูลแหละเนอะไม่มีอะไรมากหรอก
            try context.save()
        } catch let error {
            print("Error save data , \(error.localizedDescription)")
        }
        self.tableView.reloadData()
    }
    
    //    โหลดข้อมูลจาก Filemanager
//    func loadItems(){
//        if let data = try? Data(contentsOf: dataFilePath!) {
//
//            do {
//
//            } catch let error {
//                print("Error decode data, \(error)")
//            }
//        }
//    }
}


