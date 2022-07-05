//
//  ViewController.swift
//  Todoey
//
//  Created by Kittisak Panluea on 30/6/2565 BE.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    var todoItems:Results<Items>?
    
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        //        อารมณ์แบบว่าเมื่อไหร่ที่ selectedCategory มันมีการ set ค่าแล้ว ก็จะเรียกใช้ loadItems()
        didSet {
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = selectedCategory?.name ?? "Items"
        
        //        ฟังก์ชันเอาไว้ดู path ว่ามันเก็บข้อมูลไว้ตรงไหนในแอปของเรา
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //        คือปัญหามันก็มีมาอีกคือด้วยความที่เราใช้ reuse ดังนั้นมันทำให้เวลาเราเลื่อนจนหมดตารางในหน้าแรกแล้วใช่ป่ะ
        //        มันก็จะเอาตารางจากช่องที่ 1 ด้านบนสุดที่เราเลื่อนผ่านมาแล้วอะ เอากลับมาใช้ใหม่ในตารางในหน้าจอล่าง
        //        ทำให้เวลาที่เราเช็คว่าเราทำส่ิงนี้สิ่ิงนั้นไปแล้ว ทำไมมันถึงมาเช็คถูกให้กับตัวหน้าจอที่สองด้วย เพราะมันเอาช่องแรกของตารางบนมาไง
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //         อัปเดตข้อมูลใน realm
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write({
                    item.done = !item.done
                    
                    //                    ลบข้อมูลจะใช้ แบบนิ้
                    //                    realm.delete(item)
                })
            } catch let error {
                print("Error updating data \(error)")
            }
        }
        
        tableView.reloadData()
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
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write{
                        let newItem = Items()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        
                        //                ก็คือเอา todo อันนี้ไปเพิ่มให้กับประเภทของมันด้วย
                        currentCategory.items.append(newItem)
                        
                    }
                } catch let error {
                    print("Error saving data \(error)")
                }
            }
            
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
    
    //MARK: - Read Data from Realm
    
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true) ?? nil
        tableView.reloadData()
    }
}


//MARK: - SearchBarDelegate Section
extension TodoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
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
