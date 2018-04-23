//
//  ChecklistViewController.swift
//  Google Keep
//
//  Created by Satkaran Tamber on 11/3/17.
//  Copyright © 2017 David Liang. All rights reserved.
//

import UIKit

class ChecklistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var checklistTable: UITableView!
    var checklists : [Checklist] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        checklistTable.dataSource = self
        checklistTable.delegate = self
        


        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        //get the data form Core data
        getdata()
        
        //reload the table view
        checklistTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklists.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let checklist = checklists[indexPath.row]
        cell.textLabel?.text = checklist.name!
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if editingStyle == .delete {
            let checklist = checklists[indexPath.row]
            context.delete(checklist)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do{
                try checklists = context.fetch(Checklist.fetchRequest())
            }
            catch{
                print("Fetching Failed")
            }
        }
        checklistTable.reloadData()
    }
    
    
    
    func getdata(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do{
            try checklists = context.fetch(Checklist.fetchRequest())
        }
        catch{
            print("Fetching Failed")
        }
        
    }

}
