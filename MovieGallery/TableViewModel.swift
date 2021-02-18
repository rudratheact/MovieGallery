//
//  TableViewModel.swift
//  MovieGallery
//
//  Created by Rudra on 17/02/21.
//

import Foundation

class TableViewModel {
    
    private var searchedMovies = [Movie]()
    
    func fetchMoviesData(criteria: String, actionType: Type, completion: @escaping () -> ()) {
        
        let apiService = APICall(criteria: criteria, actionType: actionType)
        
        // weak self - prevent retain cycles
        apiService.getMoviesData { [weak self] (result) in
            
            switch result {
            case .success(let listOf):
                self?.searchedMovies = listOf.movies
                completion()
            case .failure(let error):
                // Something is wrong with the JSON file or the model
                print("Error processing json data: \(error)")
            }
        }
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if searchedMovies.count != 0 {
            return searchedMovies.count
        }
        return 0
    }
    
    func cellForRowAt (indexPath: IndexPath) -> Movie {
        return searchedMovies[indexPath.row]
    }
}
