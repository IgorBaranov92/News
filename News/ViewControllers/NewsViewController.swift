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
        dateLabel.text = "Дата публикации: \(newsData.pubDate.string)"
        print(newsData.description)
    }
    
    @IBAction func addToFavorite(_ sender: UIBarButtonItem) {
        
    }

}
