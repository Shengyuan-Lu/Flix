import UIKit
import AlamofireImage

class MovieDetailsViewController: UIViewController {
    
    var movie: [String:Any]!
    
    // IBOutlets
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overViewTextView: UITextView!
    @IBOutlet var superView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configView()
        
        posterImageView.layer.cornerRadius = 10
        
        bgImageView = setGradient(imageView: bgImageView)

    }
    
    func configView() {
        
        // Set the label text and the overview text
        self.titleLabel.text = movie["title"] as? String
        self.overViewTextView.text = movie["overview"] as? String
        
        // Set the base URL
        let baseURL = "https://image.tmdb.org/t/p/"
        
        let posterSize = ["w92", "w154", "w185", "w342", "w500", "original"]
        let bgSize = ["w300", "w780", "w1280", "original"]
        
        // Set the poster image
        if let posterPath = movie["poster_path"] as? String {
            let posterURL = URL(string: baseURL + posterSize[2] + posterPath)
            posterImageView.layer.shadowRadius = 10
            posterImageView.af.setImage(withURL: posterURL!)
        }
        
        // Set the bg image
        if let bgPath = movie["backdrop_path"] as? String {
            let bgURL = URL(string: baseURL + bgSize[2] + bgPath)
            bgImageView.af.setImage(withURL: bgURL!)
        }
    }
    
    func setGradient(imageView: UIImageView) -> UIImageView {
        
        let view = UIView(frame: superView.frame)
        let gradient = CAGradientLayer()
        gradient.frame = view.frame
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.0, 1.0]
        view.layer.insertSublayer(gradient, at: 0)
        imageView.addSubview(view)
        imageView.bringSubviewToFront(view)
        
        return imageView
    }
    

}
