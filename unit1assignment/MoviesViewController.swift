//
//  MoviesViewController.swift
//  unit1assignment
//
//  Created by Autumn Y Ngoc on 2/4/22.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    // create an outlet for tableView
    @IBOutlet weak var tableView: UITableView!
    
    // declare a property which is an array of dictionaries
    // syntax: [type of key] : [type of value]; () to indicate that we're creating something
    var movies = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // setting these two allows the two tableView functions below to be called
        tableView.dataSource = self
        tableView.delegate = self
    
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                 
                 
                 // access the "results" parts in the data downloaded through API, as all the info we need (title, synopsis, poster image) are all in those "results" parts. store them into the movies variable
                 // casting: as! to convert string into dictionary, because above, we declared movies as an array of dictionaries
                 
                 self.movies = dataDictionary["results"] as! [[String:Any]]
                 
                 // after having loaded data, call the 2 tableView functions again
                 self.tableView.reloadData()
                 
                 print(dataDictionary)

                    // steps summary:
                    // 1. Get the array of movies
                    // 2. Store the movies in a property to use elsewhere
                    // 3. Reload the table view data

             }
        }
        task.resume()
    }
    
    // this function asks for the number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return movies.count
    
    }
    
    // this function asks for the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        // access elements in the movies array one by one and store in the variable movie
        let movie = movies[indexPath.row]
        
        // access the title and synopsis of a movie by looking at the API and see the word "title" representing title and "overview" representing synopsis
        // perform casting: see the title as a String
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        
        // titleLabel and synopsisLabel are outlets in the MovieCell class
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        
        // add poster images to the image views
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        // combining the base url and the path of the individual poster (of each movie), we get the poster url
        // this variable is a URL data type
        let posterUrl = URL(string: baseUrl + posterPath)
        
        cell.posterView.af.setImage(withURL: posterUrl!)
        
        
        
        
        
        return cell
    
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
