import UIKit

class UpdateIntervalTableViewController: NonEditableTableViewController {

    var duration = [1,2,3,4,5]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.cellForRow(at: IndexPath(row: UserDefaults.standard.integer(forKey: Constants.updateTimeInterval), section: 0))?.editingAccessoryType = .checkmark
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return duration.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "updateDurationCell", for: indexPath)
        if let myCell = cell as? UpdateIntervalTableViewCell {
            myCell.durationLabel.text = "\(duration[indexPath.row]) мин"
            return myCell
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(duration[indexPath.row], forKey: Constants.updateTimeInterval)
        tableView.cellForRow(at: indexPath)?.editingAccessoryType = .checkmark
    }
    
}
