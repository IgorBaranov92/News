import UIKit

class NewsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var barButtonItem: UIBarButtonItem!
    @IBOutlet weak var dateLabel: UILabel!
    
    var newsData = NewsData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = newsData.title
        textView.text = newsData.description
        print(newsData.description)
    }
    
    @IBAction func addToFavorite(_ sender: UIBarButtonItem) {
        
    }

}
