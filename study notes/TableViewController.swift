//
//  TableViewController.swift
//  study notes
//
//  Created by Sergius on 06.09.2018.
//  Copyright © 2018 Sergius. All rights reserved.
//

import UIKit
import RealmSwift

class TableViewController: UITableViewController {
    
    var realm: Realm!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        realm = try! Realm()
        
       // print(Realm.Configuration.defaultConfiguration.fileURL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.realm.objects(Task.self).count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskIdentifier", for: indexPath)

        cell.textLabel?.text = self.realm.objects(Task.self)[indexPath.row].desc
        
        return cell
    }
    @IBAction func addButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: "Add task", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Name of the task"
        }
        
        let addButton = UIAlertAction(title: "Add", style: UIAlertActionStyle.default) { (action) in
            guard let text = alert.textFields?.first?.text else { return }
            if !text.isEmpty {
                let task = Task()
                task.desc = text
                task.date = Date()
                
                try! self.realm.write {
                    self.realm.add(task)
                }
                
                self.tableView.reloadData()
            }
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        
        alert.addAction(addButton)
        alert.addAction(cancelButton)
        
        present(alert, animated: true, completion: nil)
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! self.realm?.write {
                self.realm?.delete((self.realm?.objects(Task.self)[indexPath.row])!)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
