import UIKit
import Alamofire


class NewsTableViewController: UIViewController, UITableViewDataSource,UITableViewDelegate, ParserDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var news = [NewsData]()
   
    private let refreshControl = UIRefreshControl()
    private var currentIndexPath: IndexPath?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateNews()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(updateNews), for: .valueChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let currentIndexPath = currentIndexPath {
            tableView.reloadRows(at: [currentIndexPath], with: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath)
        if let myCell = cell as? NewsTableViewCell {
            myCell.title.text = news[indexPath.row].title
            myCell.title.textColor = news[indexPath.row].alreadySeen ? .gray : .black
            myCell.sourseLabel.text = "Источник: \(news[indexPath.row].author)"
            myCell.sourseLabel.textColor = news[indexPath.row].alreadySeen ? .gray : .black

        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        news[indexPath.row].alreadySeen = true
        currentIndexPath = indexPath
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc private func updateNews() {
        news.removeAll()
        DispatchQueue.global(qos: .userInitiated).async {
            for index in Sources.sources.indices {
                if let url = URL(string: Sources.sources[index]) {
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                let parser = NewsParser(data:data)
                parser.delegate = self
                self.news = parser.parse()
                }
                    task.resume()
                }
            }
        }
        
    }


    func finishParsing() {
        DispatchQueue.main.async {
            print(self.news.count)
            self.tableView.reloadData()
            self.spinner.stopAnimating()
            self.refreshControl.endRefreshing()
        }
    }
}