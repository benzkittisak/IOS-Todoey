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
    
    //            แต่ก่อนจะเรียกใช้จาก CoreData อย่าลืมว่าเราต้องมีตัว context ก่อน ดังนั้นเราจะสร้าง context ขึ้นมาก่อน
    //            UIApplication.shared.delegate คือเราใช้ตัว UIApplication นั่นแหละแล้วก้เข้าถึงข้อมูลที่มัน shared กันใน UIApplication แล้วก้เข้าถึงตัว delegate แล้วทำการเปลี่ยน type ของมันเป็น AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        ฟังก์ชันเอาไว้ดู path ว่ามันเก็บข้อมูลไว้ตรงไหนในแอปของเรา
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //        * ต่อไปเราจะมาดึงข้อมูลจาก CoreData กัน
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
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        * โค้ดข้างบนมันเยอะไปขอย่อสั้นๆแบบนี้ละกัน
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //        ถ้าจะลบข้อมูลออกจาก core data เราจะเขียนแบบนิ้
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        //        saveItems()
        
        //        ถ้าจะอัปเดตข้อมูลเราจะทำแบบนิ้
        //        itemArray[indexPath.row].setValue("Yehhh", forKey: "title")
        //        saveItems()
        
        
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
    
    //MARK: - Create a new data to CoreData
    
    func saveItems() {
        do {
            //            ก็ save ข้อมูลแหละเนอะไม่มีอะไรมากหรอก
            try context.save()
        } catch let error {
            print("Error save data , \(error.localizedDescription)")
        }
        self.tableView.reloadData()
    }
    
    
    //MARK: - Read Data from CoreData
    //        โหลดข้อมูลจาก CoreData
    func loadItems(with request:NSFetchRequest<Items> = Items.fetchRequest()){
        //        fetch ช้อมูลออกมาในรูปแบบของ Items
//        let request : NSFetchRequest<Items> = Items.fetchRequest()
        //        จากนั้นก็สั่งให้มันดึงข้อมูลออกมาเลย แต่ต้องอยู่ในรูปแบบของ docatch เหมือนกัน
        do {
            itemArray = try context.fetch(request)
            tableView.reloadData()
        } catch let error {
            print("Error fetching data , \(error.localizedDescription)")
        }
    }
}


//MARK: - SearchBarDelegate Section
extension TodoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
//        เช็คแปปว่า searchBar มีค่ามาไหมถ้าไม่มีก็ให้มัน fetch ข้อมูลทั้งหมดออกมา
//        เลิกใช้ตัวนี้แล้วไปใช้อีกตัวที่ดีกว่า
//        if searchBar.text! == "" {
//            loadItems()
//            return
//        }
        
        let request : NSFetchRequest<Items> = Items.fetchRequest()
        
        //          ต่อไปก็สั่งให้ request ใช้งานตัว predicate
        //        NSPredicate ใช้สำหรับการกำหนดเงื่อนไขเพื่อกรองข้อมูลจาก object ที่ได้จากการ fetch จาก CoreData
        //        format คือถ้าเอาง่าย ๆ คืออารมณ์แบบคำสั่ง SQL อะแหละ
        //        arguments ก็คือเราจะเอาอะไรไปใส่ในเงื่อนไขตรง format อิ %@ ก็แบบว่าเอาอิ arguments ตัว
        request.predicate = NSPredicate(format: "title CONTAINS %@", searchBar.text!)
        
        
//        สั่งให้มันเรียงข้อความแหละนะไม่มีไรหรอก เรียกจากน้อยไปมาก
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//        ต้องเป็น array เนอะเพราะตัว request.sortDescriptor มันเป็น array
        request.sortDescriptors = [sortDescriptor]
        
//        แล้วก็สั่งให้มัน fetch ข้อมูลจาก CoreData  เลยคา
        loadItems(with: request)
        
    }
    
//    หันมาใช้ตัวนี้แทนจากบรรทัดที่ 144 - 149
//    เมื่อข้อความมีการเปลี่ยนแปลงอะไร ฟังก์ชันนี้จะถูกเรียกใช้งานโดยอัตโนมัติ
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
//            ก็คือสั่งให้มันเอา คีย์บอร์ดออกนั่นแหละ
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
