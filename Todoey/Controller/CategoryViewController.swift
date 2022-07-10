//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Kittisak Panluea on 4/7/2565 BE.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categories:Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadCategories()
        tableView.rowHeight = 80.0
        
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
        
    }
    
    //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
    //        cell.delegate = self
    //        return cell
    //    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
//        สุ่มสีจาก chemeleon framework
        cell.backgroundColor = UIColor(hexString: (categories?[indexPath.row].color) ?? "#74b9ff")
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        //            มันจะบอกเลขของ row ที่เรากดเข้าไปแล้วก็ส่งไปที่อีกหน้านึงเพื่อที่จะเอาไปดึงข้อมูลตามประเภทที่เลือกมา
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    func save(category:Category) {
        do {
            try realm.write({
                realm.add(category)
            })
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategories() {
        
        //        ดึงข้อมูลแบบง่ายจัด ๆ มาจาก realm
        categories = realm.objects(Category.self)
        //      เราไม่สามารถที่จะเอาข้อมูลจาก realm ใส่ไปในตัวแปร categories ที่เราสร้างไว้เป็น global โดยตรงได้เนื่องจาก
        //        type ของข้อมูลที่ได้มาจาก realm มันเป็น Result
        //        วิธีแก้ของเราก็คือ ก็ไปเปลี่ยน type ของมันให้ตรงกันก็จบ
        tableView.reloadData()
        
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDelete = self.categories?[indexPath.row]{
            do {
                try self.realm.write({
                    self.realm.delete(categoryForDelete)
                })
            } catch let error {
                print("Error can't delete data \(error)")
            }
        }
    }
    
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat().hexValue()
            
            self.save(category: newCategory)
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        
        present(alert, animated: true, completion: nil)
        
    }
}
