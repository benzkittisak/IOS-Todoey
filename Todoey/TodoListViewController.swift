//
//  ViewController.swift
//  Todoey
//
//  Created by Kittisak Panluea on 30/6/2565 BE.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    let itemArray = ["Find Mike" , "Buy Eggos" , "Destroy Demogorgon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
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
}

