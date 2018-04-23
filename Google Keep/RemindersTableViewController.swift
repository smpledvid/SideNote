import UIKit
import CoreData
import UserNotifications

class reminderCellTableViewCell: UITableViewCell
{
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
}

var reminderList : [Reminder] = []
var selectedReminderIndex = -1

class RemindersTableViewController: UITableViewController, UNUserNotificationCenterDelegate
{
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.rowHeight = 75
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge, .sound], completionHandler: {didAllow, error in})
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        selectedReminderIndex = indexPath.row
        performSegue(withIdentifier: "showReminderSegue", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return reminderList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell", for: indexPath) as! reminderCellTableViewCell
        let reminder = reminderList[indexPath.row]
        
        cell.eventName?.text = reminder.eventName!
        let date = reminder.eventDate!
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let dateString = dateFormatter.string(from:date as Date)
        cell.date?.text = dateString
        
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        let timeString = dateFormatter.string(from:date as Date)
        cell.time?.text = timeString
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let context = delegate.persistentContainer.viewContext
            let reminder = reminderList[indexPath.row]
            deleteNotification(reminder: reminder)
            context.delete(reminder)
            delegate.saveContext()
            do
            {
                try reminderList = context.fetch(Reminder.fetchRequest())
            }
            catch
            {
                
            }
            selectedReminderIndex -= 1;
        }
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        var deliveredNotifIDs : [String] = []
        UNUserNotificationCenter.current().getDeliveredNotifications(completionHandler:)
            { notifications in
                for n in notifications
                {
                    deliveredNotifIDs.append(n.request.identifier)
                }
        }
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        var numDeleted = 0
        
        for i in deliveredNotifIDs
        {
            for j in reminderList
            {
                if (i == j.notifID)
                {
                    context.delete(j)
                    numDeleted += 1
                }
            }
        }
        
        getData()
        tableView.reloadData()
        selectedReminderIndex = -1
    }
    
    func deleteNotification(reminder: Reminder)
    {
        let eventString = reminder.eventName!
        let date = reminder.eventDate!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMMddyyhhmmss"
        let dateString = dateFormatter.string(from:date as Date)
        let notifID = eventString + dateString
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notifID])
    }
    
    func getData()
    {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        do
        {
            try reminderList = context.fetch(Reminder.fetchRequest())
        }
        catch
        {
            
        }
    }
}

