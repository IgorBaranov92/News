import UIKit

class UpdateIntervalTableViewController: NonEditableTableViewController {

    var duration = [1,2,3,4,5]

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
        tableView.deselectRow(at: indexPath, animated: true)
        UserDefaults.standard.set(indexPath.row, forKey: Constants.updateTimeIndex)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.changeUpdateTime), object: nil)

    }
    
}




