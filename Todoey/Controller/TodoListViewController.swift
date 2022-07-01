//
//  ViewController.swift
//  Todoey
//
//  Created by Kittisak Panluea on 30/6/2565 BE.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    //    ทีนี้เราเปลี่ยนมาใช้ class แล้วดังนั้นเราทำตัวแปรตัวนี้ใหม่
    //    var itemArray = ["Find Mike" , "Buy Eggos" , "Destroy Demogorgon"]
    
    //    ให้มันเป็น array ของ Item
    var itemArray = [Item]()
    //    เรียกใช้ database มาเก็บข้อมูลแหละนะ มันจะเก็บข้อมูลในรูปแบบของ Dictionary เก็บอะไรที่ไม่ได้สำคัญมากก็ได้อยู่
    //    * ไม่ใช้แล้วแหละจะไปใช้ตัว FileManager แทน
    //    let defaults = UserDefaults.standard
    
    //        ทีนี้เราจะมาแก้ปัญหาเรื่องที่ว่าตัว userdefault มันเก็บ type ที่สร้างเองไม่ได้กันโดยใช้การเก็บข้อมูลเข้าไปไว้ในไฟล์แทน
    
    //        เริ่มจากเรียกใช้ตัว FileManager
    //        userDomainMark นี่คือโฟลเดอร์ Home ของ user นั่นแหละ
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
//        let newItem = Item()
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Buy Eggos"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Destroy Demogorgon"
//        itemArray.append(newItem3)
        
        
        
        //        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
        //            itemArray = items
        //        }
        
        //        * ต่อไปเราจะมาดึงข้อมูลจาก FileManagerกัน
        loadItems()
        
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
        
        //        ทีนี้เราจะมาแก้ปัญหากัน
        //        จะใช้วิธีนี้ก็ได้
        //        let cell = UITableViewCell(style: .default, reuseIdentifier: "TodoItemCell")
        
        //        หรือจะกลับไปแก้ตัวแปรให้มันเป็น dictionary หรือทำใหม่เป็น model ไปเลยก็ได้
        //        *เหมือนเดิมคือด้วยความที่เราเปลี่ยนเป็น class ต้องมาแก้ตรงนี้ด้วย
        //        cell.textLabel?.text = itemArray[indexPath.row]
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //        if item.done {
        //            cell.accessoryType = .checkmark
        //        } else {
        //            cell.accessoryType = .none
        //        }
        //        ข้างบนมันเยอะไปขอตัดย่อให้สั้นลงอีกละกัน
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        print(itemArray[indexPath.row])
        
        //        แบบว่าทำให้เวลาเรากดไปที่ row แล้วมันจะมี checkmark ขึ้นมาข้างหลัง
        //        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        //        * ทำให้มันกดแล้วเปลี่ยนค่า done ใน class เป็น true เมื่อกด
        //        if itemArray[indexPath.row].done {
        //            itemArray[indexPath.row].done = false
        //        } else {
        //            itemArray[indexPath.row].done = true
        //        }
        //        * โค้ดข้างบนมันเยอะไปขอย่อสั้นๆแบบนี้ละกัน
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        //        tableView.reloadData()
        
        //        ทีนี้ปัญหาคือมันไม่สามารถที่จะกดซ้ำแล้วเอา checkmark ออกได้ ดังนั้นเราจะทำให้มันกดแล้วเอา checkmark ออกกัน
        //        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //        } else {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //        }
        
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
            //            เมื่อผู้ใช้กดปุ่ม Add Item บน alert จะให้มันทำอะไรต่อ
            //            * แก้ตรงนี้ด้วยจากของธรรมดาให้เป็นคลาส
            //            self.itemArray.append(textField.text!)
            let newItem = Item()
            newItem.title = textField.text!
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
        //            set ค่าให้กับตัว defaults
        //            ต้องเปลี่ยนแล้วล่ะ userdefault มันไม่สามารถที่จะเก็บข้อมูลที่เป็น custom type ได้
        //            self.defaults.set(self.itemArray, forKey: "TodoListArray")
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch let error {
            print("Error encoding item array , \(error.localizedDescription)")
        }
        self.tableView.reloadData()
    }
    
    //    โหลดข้อมูลจาก Filemanager
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!) {
            //            เรา encode ข้อมูลมาใช่ป่ะ เราก้ต้อง decode ตอนให้มันอ่านข้อมูล
            let decoder = PropertyListDecoder()
            
            do {
                //        decode(ตัวแรกเป็น type ของข้อมูลที่จะให้มันเป็น , ตัวที่สองคือข้อมูลที่จะ decode เอามาจากไหน)
                itemArray = try decoder.decode([Item].self, from: data)
                
            } catch let error {
                print("Error decode data, \(error)")
            }
        }
    }
}


