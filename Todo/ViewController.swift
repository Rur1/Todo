//
//  ViewController.swift
//  Todo
//
//  Created by 瑠璃 on 2019/01/30.
//  Copyright © 2019 瑠璃. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    let realm = try! Realm()
    
    override func viewDidLoad() {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let todos = realm.objects(Todo.self)
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Todo", for: indexPath)
        let todos = realm.objects(Todo.self)
        cell.textLabel!.text = todos[indexPath.row].text
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.delete(index: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    @IBAction func addTodo(_ sender: UIButton) {
        let alert = UIAlertController(title: "新規Todo", message: "", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in for textField in alert.textFields! {
            if !textField.text!.isEmpty {
                self.add(text: textField.text!)
            }
            self.tableView.reloadData()
            }})
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        alert.addTextField(configurationHandler: {(text) -> Void in text.returnKeyType = .done})
        present(alert, animated: true)
    }
    
    func add(text: String) {
        let todo = Todo()
        todo.text = text
        try! realm.write {
            realm.add(todo)
        }
    }
    
    func delete(index: Int) {
        let todos = realm.objects(Todo.self)
        try! realm.write {
            realm.delete(todos[index])
        }
    }
    
}
