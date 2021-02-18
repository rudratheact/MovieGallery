//
//  TableViewController.swift
//  MovieGallery
//
//  Created by Rudra on 17/02/21.
//

import UIKit

class TableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchMovies: UISearchBar!
    
    private var viewModel = TableViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchMovies.delegate = self
        
        loadNowPlayingMoviesData(criteria: "now_playing", actionType: .normal)
        self.title = "Now Playing"
        tableView.reloadData()
    }
    
    @IBAction func popularMovies(_ sender: UIBarButtonItem) {
        loadNowPlayingMoviesData(criteria: "popular", actionType: .normal)
        self.title = "Popular Movies"
        tableView.reloadData()
    }
    
    @IBAction func bestMovies(_ sender: UIBarButtonItem) {
        loadNowPlayingMoviesData(criteria: "top_rated", actionType: .normal)
        self.title = "Best Movies"
        tableView.reloadData()
    }
    
    private func loadNowPlayingMoviesData(criteria: String, actionType: Type) {
        viewModel.fetchMoviesData(criteria: criteria, actionType: actionType){ [weak self] in
               self?.tableView.dataSource = self
               self?.tableView.reloadData()
           }
       }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.numberOfRowsInSection(section: section)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Table_Cell, for: indexPath) as! TableViewCell

        // Configure the cell...
        let movie = viewModel.cellForRowAt(indexPath: indexPath)
        cell.setCellWithValuesOf(movie)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Segue_ID, sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == Segue_ID{
            let destination = segue.destination as! DetailsViewController
            let movie = viewModel.cellForRowAt(indexPath: tableView.indexPathForSelectedRow!)
            destination.popularMovie = [movie]
        }
        
    }
    
    // MARK:- Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){ // called when text changes (including clear)
        print(searchText)
        loadNowPlayingMoviesData(criteria: searchText, actionType: .search)
        self.title = "Search Movies"
        
        tableView.reloadData()
    }

}
