import UIKit
import CoreData


class FavoriteNewsViewController: TableViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert : tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete : tableView.deleteRows(at: [indexPath!], with: .fade)
        default:break
        }
    }
    
    
    lazy var fetchedResultsController : NSFetchedResultsController<News>? = {
        let request : NSFetchRequest<News> = NSFetchRequest(entityName: "News")
        request.sortDescriptors = [NSSortDescriptor(key:"pubDate",ascending:false)]
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: AppDelegate.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = self
        try? aFetchedResultsController.performFetch()
        return aFetchedResultsController
    }()
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return fetchedResultsController?.sections![0].numberOfObjects ?? 0
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath)
        if let myCell = cell as? NewsTableViewCell,let news = fetchedResultsController?.object(at: indexPath) {
               myCell.title.text = news.title
               myCell.sourseLabel.text = "Источник: \(news.author ?? ""))"
               myCell.url = URL(string:news.url ?? "")
               myCell.sourseLabel.isHidden = !UserDefaults.standard.bool(forKey: Constants.shouldHideSources)
               }
           
           return cell
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
          let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") {[weak self] (action,indexPath) in
              let alert = UIAlertController(title: "Подтвержение", message: "Вы действительно хотите удалить эту новость?", preferredStyle: .alert)
              let cancelAction = UIAlertAction(title: "Нет", style: .cancel)
              let doneAction = UIAlertAction(title: "Да", style: .default) { (action) in
                  let object = self?.fetchedResultsController?.object(at: indexPath)
                  AppDelegate.viewContext.delete(object!)
                  try? AppDelegate.viewContext.save()
                self?.tableView.reloadData()
              }
              alert.addAction(doneAction)
              alert.addAction(cancelAction)
              self?.present(alert, animated: true)
          }
          deleteAction.backgroundColor = UIColor.red
          return [deleteAction]
      }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? NewsTableViewCell,let indexPath = tableView.indexPath(for: cell),let destinationVC = segue.destination as? NewsViewController, segue.identifier == "showFNews",let news = fetchedResultsController?.object(at: indexPath) {
            let newsData = NewsData()
            newsData.title = news.title ?? ""
            newsData.description = news.body ?? ""
            newsData.pubDate = news.pubDate ?? Date()
            destinationVC.newsData = newsData
            destinationVC.favorite = true
        }
    }
    
    
    
}
