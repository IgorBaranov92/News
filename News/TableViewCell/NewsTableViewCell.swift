import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var sourseLabel: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var url: URL? { didSet { updateUI() }}
    
    private func updateUI() {
        if let imageURL = url {
            spinner.startAnimating()
            picture.image = nil
            DispatchQueue.global(qos: .userInitiated).async {
                let urlContents = try? Data(contentsOf: imageURL)
                if let data = urlContents, imageURL == self.url {
                    DispatchQueue.main.async { [unowned self] in
                        self.picture.image = UIImage(data: data)
                        self.spinner.stopAnimating()
                    }
                }
            }
        }
    }
    
}
