import UIKit
import CoreData

var noteList : [Note] = []
var selectedNotesIndex = -1

class NoteTableViewCell: UITableViewCell
{
    @IBOutlet weak var noteTitle: UILabel!
    @IBOutlet weak var noteDate: UILabel!
    @IBOutlet weak var noteBody: UILabel!
}

class NotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
   
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        selectedNotesIndex = indexPath.row
        performSegue(withIdentifier: "showNoteSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return noteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteTableViewCell
        let note = noteList[indexPath.row]
        self.tableView.rowHeight = 75
        cell.noteTitle?.text = note.noteTitle!
        cell.noteBody?.text = note.noteBody!
        cell.noteDate?.text = note.noteDate!
        cell.noteBody?.textAlignment = NSTextAlignment.left
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let context = delegate.persistentContainer.viewContext
            let note = noteList[indexPath.row]
            context.delete(note)
            delegate.saveContext()
            do
            {
                try noteList = context.fetch(Note.fetchRequest())
            }
            catch
            {
                
            }
            selectedNotesIndex -= 1;
        }
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        getData()
        print(noteList.count)
        tableView.reloadData()
        selectedNotesIndex = -1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 75
    }
    
    func getData()
    {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        do
        {
            try noteList = context.fetch(Note.fetchRequest())
        }
        catch
        {
            
        }
    }
}


