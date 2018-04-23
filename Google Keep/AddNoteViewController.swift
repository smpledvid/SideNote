import UIKit
import CoreData

class AddNoteViewController: UIViewController
{
    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var noteBody: UITextView!
    
    var labelString: String?
    
    @IBAction func saveButton(_ sender: UIBarButtonItem)
    {
        if ( !(noteTitle.text!.isEmpty) )
        {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let context = delegate.persistentContainer.viewContext
            var note = Note()
            
            if (selectedNotesIndex > -1)
            {
                note = noteList[selectedNotesIndex]
            }
            else if (selectedItemIndex > -1)
            {
                note = listOfLabelItems[selectedItemIndex]
            }
            else
            {
                note = Note(context: context)
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let dateString = dateFormatter.string(from:Date())
            note.noteTitle = noteTitle.text!
            note.noteBody = noteBody.text!
            note.noteDate = dateString
            
            if ( labelString != nil )
            {
                note.label = labelString!
            }
            
            selectedNotesIndex = -1
            selectedItemIndex = -1
            labelString = nil
            delegate.saveContext()
            navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if (selectedNotesIndex > -1)
        {
            noteTitle.text = noteList[selectedNotesIndex].noteTitle
            noteBody.text = noteList[selectedNotesIndex].noteBody
        }
        else if (selectedItemIndex > -1)
        {
            noteTitle.text = listOfLabelItems[selectedItemIndex].noteTitle
            noteBody.text = listOfLabelItems[selectedItemIndex].noteBody
        }
    }
}

