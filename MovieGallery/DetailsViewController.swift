//
//  ViewController.swift
//  MovieGallery
//
//  Created by Rudra on 17/02/21.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var ratting: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieDescription: UILabel!
    
    var popularMovie = [Movie]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let selectedMovie = popularMovie.first
        
        movieTitle.text = selectedMovie?.title
        releaseDate.text = selectedMovie?.year
        if let rate = selectedMovie?.rate{
            ratting.text = String(describing: rate)
        }else{
            ratting.text = "None"
        }
        movieDescription.text = selectedMovie?.overview
        
        guard let posterString = selectedMovie?.posterImage else {return}
        let urlString = "https://image.tmdb.org/t/p/w300" + posterString
        
        guard let posterImageURL = URL(string: urlString) else {
            self.moviePoster.image = UIImage(named: defaultImage)
            return
        }
        self.moviePoster.image = nil
        
        getImageDataFrom(url: posterImageURL)
    }
    
    // MARK: - Get image data
    private func getImageDataFrom(url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Handle Error
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                // Handle Empty Data
                print("Empty Data")
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.moviePoster.image = image
                }else{
                    self.moviePoster.image = UIImage(named: defaultImage)
                }
            }
        }.resume()
    }
    
}

