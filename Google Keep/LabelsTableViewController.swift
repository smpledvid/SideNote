import UIKit
import CoreData

var listOfLabelItems : [Note] = []
var selectedItemIndex = -1

class LabelNoteTableViewCell: UITableViewCell
{
    @IBOutlet weak var noteTitle: UILabel!
    @IBOutlet weak var noteDate: UILabel!
    @IBOutlet weak var noteBody: UILabel!
}

class LabelsTableViewController: UITableViewController
{
    var labelString: String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = labelString
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        getData()
        tableView.reloadData()
        selectedItemIndex = -1
    }

    @IBAction func addButton(_ sender: UIBarButtonItem)
    {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "AddNoteView") as! AddNoteViewController
        viewController.labelString = labelString
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        selectedItemIndex = indexPath.row
        let viewController = storyboard?.instantiateViewController(withIdentifier: "AddNoteView") as! AddNoteViewController
        viewController.labelString = labelString
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelNoteCell", for: indexPath) as! LabelNoteTableViewCell
        let note = listOfLabelItems[indexPath.row]
        self.tableView.rowHeight = 75
        cell.noteTitle?.text = note.noteTitle!
        cell.noteBody?.text = note.noteBody!
        cell.noteDate?.text = note.noteDate!
        cell.noteBody?.textAlignment = NSTextAlignment.left
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let context = delegate.persistentContainer.viewContext
            let note = listOfLabelItems[indexPath.row]
            context.delete(note)
            delegate.saveContext()
            getData()
        }
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return listOfLabelItems.count
    }
    
    func getData()
    {
        var allNotes : [Note] = []
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        do
        {
            try allNotes = context.fetch(Note.fetchRequest())
        }
        catch
        {
            
        }
        
        for note in allNotes
        {
            if (note.label == labelString)
            {
                listOfLabelItems.append(note)
            }
        }
    }
}
