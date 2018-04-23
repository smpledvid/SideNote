import UIKit
import CoreData
import UserNotifications

class AddReminderTableViewController: UITableViewController
{
    let NUM_OF_CELLS = 14
    let EVENT_NAME_INDEX_PATH = 1
    let EVENT_DATE_INDEX_PATH = 3
    
    var selectedIndexPath: IndexPath?
    
    /*
    @IBAction func saveButton(_ sender: UIBarButtonItem)
    {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        var reminder = Reminder()
        
        if (selectedReminderIndex > -1)
        {
            reminder = reminderList[selectedReminderIndex]
        }
        else
        {
            reminder = Reminder(context: context)
        }
        
        createNewNotification()
        
        let indexPathEvent = IndexPath(row: EVENT_NAME_INDEX_PATH, section: 0)
        let eventCell = tableView.cellForRow(at: indexPathEvent) as! eventNameCellTableViewCell
        
        let indexPathDate = IndexPath(row: EVENT_DATE_INDEX_PATH, section: 0)
        let dateCell = tableView.cellForRow(at: indexPathDate) as! datePickerCellTableViewCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMMddyyhhmmss"
        let notifDateStr = dateFormatter.string(from:dateCell.datePicker.date as! Date)
        let notifEventStr = eventCell.eventName.text!
        let notifID = notifEventStr + notifDateStr
        
        reminder.eventName = eventCell.eventName.text!
        reminder.eventDate = dateCell.datePicker.date as NSDate
        reminder.notifID = notifID
        
        selectedReminderIndex = -1
        delegate.saveContext()
        navigationController?.popViewController(animated: true)
    }
 
 */
    @IBAction func saveButton(_ sender: UIBarButtonItem)
    {
        let indexPath = IndexPath(row: EVENT_NAME_INDEX_PATH, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! eventNameCellTableViewCell
    
        if ( !((cell.eventName.text?.isEmpty)! ) )
        {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let context = delegate.persistentContainer.viewContext
            var reminder = Reminder()
        
            if (selectedReminderIndex > -1)
            {
                reminder = reminderList[selectedReminderIndex]
            }
            else
            {
                reminder = Reminder(context: context)
            }
        
            createNewNotification()
        
            let indexPathEvent = IndexPath(row: EVENT_NAME_INDEX_PATH, section: 0)
            let eventCell = tableView.cellForRow(at: indexPathEvent) as! eventNameCellTableViewCell
        
            let indexPathDate = IndexPath(row: EVENT_DATE_INDEX_PATH, section: 0)
            let dateCell = tableView.cellForRow(at: indexPathDate) as! datePickerCellTableViewCell
        
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMMddyyhhmmss"
            let notifDateStr = dateFormatter.string(from:dateCell.datePicker.date as! Date)
            let notifEventStr = eventCell.eventName.text!
            let notifID = notifEventStr + notifDateStr
        
            reminder.eventName = eventCell.eventName.text!
            reminder.eventDate = dateCell.datePicker.date as NSDate
            reminder.notifID = notifID
        
            selectedReminderIndex = -1
            delegate.saveContext()
            navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (indexPath.row == EVENT_DATE_INDEX_PATH)
        {
            return 200
        }
        
        return 44
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return NUM_OF_CELLS
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == EVENT_NAME_INDEX_PATH
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "eventNameCell", for: indexPath) as! eventNameCellTableViewCell
            if (selectedReminderIndex > -1)
            {
                cell.eventName?.text = reminderList[selectedReminderIndex].eventName
            }
            return cell
        }
        else if indexPath.row == EVENT_DATE_INDEX_PATH
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "datePickerCell", for: indexPath) as! datePickerCellTableViewCell
            cell.datePicker.minimumDate = Date()
            if (selectedReminderIndex > -1)
            {
                let date = reminderList[selectedReminderIndex].eventDate
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM dd, yyyy @ hh:mm a"
                let dateString = dateFormatter.string(from:date as! Date)
                
                cell.datePicker?.date = date! as Date
                cell.dateTime?.text = dateString
            }
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "blankCell", for: indexPath) as! blankCellTableViewCell
            return cell
        }
    }
    
    func createNewNotification()
    {
        let indexPathEvent = IndexPath(row: EVENT_NAME_INDEX_PATH, section: 0)
        let eventCell = tableView.cellForRow(at: indexPathEvent) as! eventNameCellTableViewCell
        
        let indexPathDate = IndexPath(row: EVENT_DATE_INDEX_PATH, section: 0)
        let dateCell = tableView.cellForRow(at: indexPathDate) as! datePickerCellTableViewCell
        
        let content = UNMutableNotificationContent()
        content.title = eventCell.eventName.text!
        
        let date = dateCell.datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy @ hh:mm a"
        let dateString = dateFormatter.string(from:date as! Date)
        content.subtitle = dateString
        content.badge = 1
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: date)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        
        dateFormatter.dateFormat = "MMMMddyyhhmmss"
        let notifDateStr = dateFormatter.string(from:date as! Date)
        let notifEventStr = eventCell.eventName.text!
        let notifID = notifEventStr + notifDateStr
        
        let request = UNNotificationRequest(identifier: notifID, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        {(error) in
            if let error = error
            {
                print("Uh oh! We had an error: \(error)")
            }
        }
    }
    
}

/*
 * Custom cell classes:
 */

class blankCellTableViewCell: UITableViewCell
{
}

class eventNameCellTableViewCell: UITableViewCell
{
    @IBOutlet weak var eventName: UITextField!
}

class datePickerCellTableViewCell: UITableViewCell
{
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateTime: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
}

