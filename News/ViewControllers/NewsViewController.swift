import UIKit
import CoreData

class NewsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView! { didSet {
        textView.isScrollEnabled = true
        }}
    @IBOutlet weak var barButtonItem: UIBarButtonItem!
    @IBOutlet weak var dateLabel: UILabel!
    
    var newsData = NewsData()
    var favorite = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = newsData.title
        textView.text = newsData.description
        dateLabel.text = "Дата публикации: \(newsData.pubDate.string)"
        if favorite { barButtonItem.image = nil }
    }
    
    @IBAction func addToFavorite(_ sender: UIBarButtonItem) {
        if !newsData.favorite {
            let news = News(context: AppDelegate.viewContext)
            news.title = newsData.title
            news.pubDate = newsData.pubDate
            news.url = newsData.imageURL
            news.author = newsData.author
            news.body = newsData.description
            try? AppDelegate.viewContext.save()
            newsData.favorite = true
        }
    }

}
