import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController {
    
    // Create an empty array of movies
    var moviesArray = [[String : Any]]()
    
    // IBOutlet
    @IBOutlet weak var movieCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieCollectionView.dataSource = self
        movieCollectionView.delegate = self
        
        getData()
    }
    
    // Get data from the internet and store it in the moviesArray
    func getData() {
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { [self] (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                
                // Get the array of movies
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                // Store the movies in a property to use elsewhere
                self.moviesArray = dataDictionary["results"] as! [[String : Any]]
                
                print(self.moviesArray)
                
                // Reload collectionview view data
                self.movieCollectionView.reloadData()
                
            }
        }
        
        task.resume()
    }
    
}

// Collection view functionc here
extension MovieGridViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        
        let movie = moviesArray[indexPath.item]
        
        let baseURL = "https://image.tmdb.org/t/p/w500"
        let posterPath = movie["poster_path"] as! String
        let posterURL = URL(string: baseURL + posterPath)
        
        cell.posterPic.af.setImage(withURL: posterURL!)
        
        return cell
    }
    
}
