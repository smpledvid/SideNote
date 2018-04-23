import UIKit

var labels = ["Notes", "Reminders", "Checklist" ,"Photos"]
var viewID = ["NotesView", "RemindersView", "ChecklistView", "PhotosView"]

class LabelTableViewCell: UITableViewCell
{
    @IBOutlet weak var labelName: UILabel!
}

class TableViewController: UITableViewController {
    
    /* Add a new label */
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Label", message: nil, preferredStyle: .alert)
        alert.addTextField { (labelTF) in
            labelTF.placeholder = "Enter Label Name"
        }
        let action = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let userLabel = alert.textFields?.first?.text else { return }
            //print(userLabel)
            self.add(userLabel) // Also need to include a way to go to another view for each new label
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    /* Allows the user to add rows */
    func add(_ userLabel: String) {
        let index = 0
        labels.insert(userLabel, at: index)
        viewID.insert("LabelView", at: index)
        
        let indexPath = IndexPath(row: index, section: 0)
        tableView.insertRows(at: [indexPath], with: .left)
    }
    
    /* Enables deleting rows */
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    
    {
        guard editingStyle  == .delete else { return }
        labels.remove(at: indexPath.row)
        viewID.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    /* Only allow for user-created labels to be deleted*/
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        if (indexPath.row < labels.count - 4)
        {
            return true
        }
        
        return false
        
    }

    /* Used to access number of rows */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return labels.count
    }
    
    /* Used to display all the rows */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell" , for: indexPath) //as! LabelTableViewCell
        cell.textLabel?.text = labels[indexPath.row]
        //cell.labelName?.text = labels[indexPath.row]
        return cell
    }

    /* Allows each row to go to their own View */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {

        let vcName = viewID[indexPath.row]
        if (indexPath.row < labels.count - 4)
        {
            let viewController = storyboard?.instantiateViewController(withIdentifier: "LabelsView") as! LabelsTableViewController
            viewController.labelString = labels[indexPath.row]
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else
        {
            let viewController = storyboard?.instantiateViewController(withIdentifier: vcName)
            self.navigationController?.pushViewController(viewController!, animated: true)
            
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let indexPath = self.tableView.indexPathForSelectedRow {
//            let guest = segue.destination as! UserLabelViewController
//            guest.viewTitle = labels[indexPath.row]
//        }
//    }

}
