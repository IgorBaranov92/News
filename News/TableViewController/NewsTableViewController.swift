import UIKit


class NewsTableViewController: TableViewController, UITableViewDataSource,UITableViewDelegate {
    
    var news = [NewsData]()
   
    private weak var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateNews()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(updateNews), for: .valueChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(updateNewsByTimer), name: NSNotification.Name(rawValue: Constants.changeUpdateTime), object: nil)

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
            myCell.url = URL(string:news[indexPath.row].imageURL )
            myCell.sourseLabel.isHidden = !UserDefaults.standard.bool(forKey: Constants.shouldHideSources)
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
        spinner.startAnimating()
        let group = DispatchGroup()
        DispatchQueue.concurrentPerform(iterations: Sources.sources.count) { (index) in
            if let url = URL(string: Sources.sources[index]) {
                group.enter()
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                let parser = NewsParser(data:data)
                self.news += parser.parse()
                group.leave()
                }
                    task.resume()
            }
        }
        group.notify(queue: .main, execute: finishParsing)
        
    }


    func finishParsing() {
        DispatchQueue.main.async {
            self.news.sort()
            self.tableView.reloadData()
            self.spinner.stopAnimating()
            self.refreshControl.endRefreshing()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? NewsTableViewCell,let indexPath = tableView.indexPath(for: cell),let destinationVC = segue.destination as? NewsViewController, segue.identifier == "showNews" {
            destinationVC.newsData = news[indexPath.row]
        }
    }
    
    
    @objc private func updateNewsByTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: Intervals.intervals[UserDefaults.standard.integer(forKey: Constants.updateTimeIndex)] ?? 60.0, target: self, selector: #selector(updateNews), userInfo: nil, repeats: true)
    }
    
}
