//
//  APICall.swift
//  MovieGallery
//
//  Created by Rudra on 17/02/21.
//

import Foundation

enum Type{
    case search, normal
}

class APICall{
    
    private var results = [Any]()
    private var dataTask: URLSessionDataTask?
    
    private var criteria = String()
    
    private var actionType:Type
    
    init(criteria: String, actionType:Type) {
        self.criteria = criteria
        self.actionType = actionType
    }
    
    func makeURLString() -> String {
        switch actionType {
        case .search:
            return "https://api.themoviedb.org/3/search/movie?api_key=\(API_KEY)&query=\(criteria)"
        default:
            return "https://api.themoviedb.org/3/movie/\(criteria)?api_key=\(API_KEY)&language=en-US&page=1"
        }
    }
    
        func getMoviesData(completion: @escaping (Result<MoviesData, Error>) -> Void) {
            
            let moviesURL = makeURLString()
            
            guard let url = URL(string: moviesURL) else {return}
            
            // Create URL Session - work on the background
            dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                // Handle Error
                if let error = error {
                    completion(.failure(error))
                    print("DataTask error: \(error.localizedDescription)")
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    // Handle Empty Response
                    print("Empty Response")
                    return
                }
                print("Response status code: \(response.statusCode)")
                
                guard let data = data else {
                    // Handle Empty Data
                    print("Empty Data")
                    return
                }
                
                do {
                    // Parse the data
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(MoviesData.self, from: data)
                    
                    // Back to the main thread
                    DispatchQueue.main.async {
                        print(jsonData)
                        completion(.success(jsonData))
                    }
                } catch let error {
                    completion(.failure(error))
                }
                
            }
            dataTask?.resume()
        }
    
}
