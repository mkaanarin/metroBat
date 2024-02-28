//
//  HamburgerMenu.swift
//  metroBat
//
//  Created by Mustafa Kaan Arın on 16.02.2024.
//

import UIKit
import Firebase

extension UILabel {
    func setText(_ text: String?) {
        DispatchQueue.main.async {
            self.text = text
        }
    }
}

extension UIImageView {
        
    func loadImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }

        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: imageURL) {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
        }
    }
}

struct MovieInfo {
    let title: String
    let image: UIImage?
    let info: String
}


struct ResponseData: Codable {
    let results: [Movie]
}

struct Movie: Codable {
        
        let title: String
        let posterPath: String
        let overview: String
        
    
    enum CodingKeys: String, CodingKey {
        case overview, title
        case posterPath = "poster_path"
        
    }
    
    func loadPosterImage(completion: @escaping (UIImage?) -> Void) {
            guard let url = URL(string: "https://image.tmdb.org/t/p/w500" + posterPath) else {
                completion(nil)
                return
            }

            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let imageData = try Data(contentsOf: url)
                    let image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        completion(image)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
        }
}


class HamburgerMenu: UITableViewController {
    var movies: [Movie] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HamburgerCell.self, forCellReuseIdentifier: "hamburgerCell")
        loadApi()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hamburgerCell", for: indexPath) as! HamburgerCell
        
        let movie = movies[indexPath.row]
        
        movie.loadPosterImage { (image) in
                DispatchQueue.main.async {
                    cell.customImageView.image = image
                }
            }
        
        cell.configureCell(movie: movie)
        return cell
    }
    
    func loadApi() {
        let url = URL(string: "https://api.themoviedb.org/3/trending/all/week?api_key=e43abf92d45cfe38f9334b0cb4954796")

        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let error = error {
                self.makeAlert(titleInput: "Error", messageInput: "Veriler Çekilemedi. \(error.localizedDescription)")
            } else if let data = data {
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let results = jsonResponse["results"] as? [[String: Any]] {
                            for result in results {
                                if let poster = result["poster_path"] as? String,
                                   let name = result["title"] as? String,
                                   let movieInfo = result["overview"] as? String {
                                    let movie = Movie(title: name, posterPath: poster, overview: movieInfo)
                                    self.movies.append(movie)
                                }
                            }

                            DispatchQueue.main.async {
                                self.tableView.reloadData()

                            }
                        }
                    }
                } catch {
                    self.makeAlert(titleInput: "Error", messageInput: "Data Çekilemedi. \(error.localizedDescription)")
                }
            }
        }.resume()
    }

    @IBAction func logOut(_ sender: Any) {
        
        makeAlert(titleInput: "Çıkış Yapılıyor", messageInput: "Çıkış yapmak istediğinize emin misiniz?")

        }

    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: .default) { (action) in
            do{
                try Auth.auth().signOut()
                self.performSegue(withIdentifier: "toLogin", sender: nil)
            }
            catch{
            }}
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                }
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "toDetails", 
                let selectedIndex = tableView.indexPathForSelectedRow?.row {
                let destinationVC = segue.destination as! infoView
                    let selectedMovie = movies[selectedIndex]
                    
                selectedMovie.loadPosterImage { (image) in
                    DispatchQueue.main.async {
                        destinationVC.imageView.image = image
                }
                               }
                destinationVC.selectedInfo = String(selectedMovie.overview)
                destinationVC.selectedTitle = String(selectedMovie.title)
                
            }
        }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetails", sender: nil)
    
    }
}

