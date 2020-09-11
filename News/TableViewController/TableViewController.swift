import UIKit

class TableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    let refreshControl = UIRefreshControl()
    var currentIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: Constants.shouldHideSources), object: nil)
    }
    
    @objc private func refresh() {
        tableView.reloadData()
    }
    
}
