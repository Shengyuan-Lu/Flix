import UIKit
import AlamofireImage

class MoviesViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var movieTableView: UITableView!
    
    // Create an empty array of movies
    var moviesArray = [[String : Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        
        movieTableView.delegate = self
        movieTableView.dataSource = self
        
        print(moviesArray)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Find the selected Movie
        let cell = sender as! UITableViewCell
        let indexPath = movieTableView.indexPath(for: cell)!
        let movie = moviesArray[indexPath.row]
        
        // Pass the selected movie to the detail view controller
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie
    }
    
    // Get data from the internet and store it in the moviesArray
    func getData() {
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                
                // Get the array of movies
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                // Store the movies in a property to use elsewhere
                self.moviesArray = dataDictionary["results"] as! [[String : Any]]
                
                // Reload your table view data
                self.movieTableView.reloadData()
                
            }
        }
        
        task.resume()
    }
    
}

extension MoviesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create a cell
        let cell = movieTableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        // Get a movie from moviesArray
        let movie = moviesArray[indexPath.row]
        
        // Set the title and the overview text of the tableview cell
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        cell.titleLabel.text = title
        cell.bodyLabel.text = overview
        
        // Set the image view of the cell
        let baseURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterURL = URL(string: baseURL + posterPath)
        
        cell.posterPic.af.setImage(withURL: posterURL!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
