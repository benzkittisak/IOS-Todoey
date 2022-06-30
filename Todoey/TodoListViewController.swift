//
//  ViewController.swift
//  Todoey
//
//  Created by Kittisak Panluea on 30/6/2565 BE.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["Find Mike" , "Buy Eggos" , "Destroy Demogorgon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        //        แบบว่าทำให้เวลาเรากดไปที่ row แล้วมันจะมี checkmark ขึ้นมาข้างหลัง
//        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
//        ทีนี้ปัญหาคือมันไม่สามารถที่จะกดซ้ำแล้วเอา checkmark ออกได้ ดังนั้นเราจะทำให้มันกดแล้วเอา checkmark ออกกัน
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
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
            self.itemArray.append(textField.text!)
            self.tableView.reloadData()

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
}


