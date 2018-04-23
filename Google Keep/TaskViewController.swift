//
//  TaskViewController.swift
//  Google Keep
//
//  Created by Satkaran Tamber on 11/3/17.
//  Copyright © 2017 David Liang. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController {

    @IBOutlet weak var CheckListName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func SaveTapped(_ sender: Any) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if ( !(CheckListName.text!.isEmpty) ){
            let checklist = Checklist(context: context)
            checklist.name = CheckListName.text!
            print(checklist.name!)
            //saving the data
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            navigationController!.popViewController(animated: true)
        }
    }
    

}
