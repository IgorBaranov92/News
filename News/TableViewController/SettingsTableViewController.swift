import UIKit

class SettingsTableViewController: NonEditableTableViewController {

    @IBOutlet weak var showSourseSwitcher: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showSourseSwitcher.isOn = UserDefaults.standard.bool(forKey: Constants.shouldHideSources)
    }
    
    
    @IBAction func toggle(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: Constants.shouldHideSources)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.shouldHideSources), object: nil)
    }
   
   
}
