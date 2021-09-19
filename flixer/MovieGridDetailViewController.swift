//
//  MovieGridDetailViewController.swift
//  flixer
//
//  Created by Hew, Vincent on 9/17/21.
//

import UIKit
import AlamofireImage

class MovieGridDetailViewController: UIViewController {
    @IBOutlet weak var backdropView: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!

    
    var movie: [String: Any]!
    var trailer = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.text = movie["title"] as? String
        titleLabel.sizeToFit()
        synopsisLabel.text = movie["overview"] as? String
        synopsisLabel.sizeToFit()

        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        posterView.af_setImage(withURL: posterUrl!)
        
        let backdropPath = movie["backdrop_path"] as! String
        let backdropUrl = URL(string: "https://image.tmdb.org/t/p/w780" + backdropPath)
        
        backdropView.af_setImage(withURL: backdropUrl!)
        
        // Tap gesture recognizer
        let trailerTap = UITapGestureRecognizer(target: self, action: #selector(showTrailer(_:)))
        trailerTap.numberOfTapsRequired = 1
        posterView.isUserInteractionEnabled = true
        posterView.addGestureRecognizer(trailerTap)
        
        // Getting video url
        // Get the movie id
        let movieID = movie["id"] as! Int
        let upperUrl = "https://api.themoviedb.org/3/movie/"
        let bottomUrl = "/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
    
        let url = URL(string: upperUrl + "\(movieID)" + bottomUrl)!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                print(error.localizedDescription)
             } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    
                self.trailer = dataDictionary["results"] as! [[String:Any]]
                print(self.trailer)
             }
        }
        task.resume()
        
    }
    
    // Tap to perform segue
    @IBAction func showTrailer(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "trailerSegue", sender: nil)
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        print("Loading up the trailer screen")
        
        // Passing url to TrailerViewController
        let trailerViewController = segue.destination as! TrailerViewController
        var flag = false
        for source in trailer {
            if source["type"] as! String == "Trailer" {
                trailerViewController.videoInfo = source
                flag = true
            }
        }
        if flag == false {
            trailerViewController.videoInfo = trailer[0]
        }
    }
}
