//
//  TableViewCell.swift
//  MovieGallery
//
//  Created by Rudra on 17/02/21.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    
    private var urlString: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setCellWithValuesOf(_ movie:Movie) {
        updateUI(title: movie.title, poster: movie.posterImage)
    }
    
    // Update the UI Views
        private func updateUI(title: String?, poster: String?) {
            
            self.movieName.text = title
            guard let posterString = poster else {return}
            urlString = "https://image.tmdb.org/t/p/w300" + posterString
            
            guard let posterImageURL = URL(string: urlString) else {
                self.posterImage.image = UIImage(named: defaultImage)
                return
            }
            self.posterImage.image = nil

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
                        self.posterImage.image = image
                    }
                }
            }.resume()
        }
    
}
