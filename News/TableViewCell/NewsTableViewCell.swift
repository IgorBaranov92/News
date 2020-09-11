import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var sourseLabel: UILabel!
    @IBOutlet weak var title: UILabel!
    
    var url: URL? { didSet { updateUI() }}
    
    private func updateUI() {
        if let imageURL = url {
            picture.image = nil
            DispatchQueue.global(qos: .userInitiated).async {
                let urlContents = try? Data(contentsOf: imageURL)
                if let data = urlContents, imageURL == self.url {
                    DispatchQueue.main.async {
                        self.picture.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    
}
