//
//  ContentTableViewCell.swift
//  Movie_Task
//
//  Created by Bushara Siddiqui on 29/06/24.
//

import UIKit

enum ContentState {
    case movie
    case other
}

struct Details {
    var selectArray: String
    var isExpandable: Bool
}
protocol ContentTableViewCellDelegate: AnyObject {
    func didSelectMovie(movie: Movie)
}
class ContentTableViewCell: UITableViewCell{
    
    
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentTypeLbl: UILabel!
    weak var delegate: ContentTableViewCellDelegate?
    var movies: [Movie] = []
    var movieList = [MovieList]()
    var contentState: ContentState = .other
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.dataSource = self
        tableView.delegate = self
        registerTableView()
    }
    
    func registerTableView() {
        tableView.register(UINib(nibName: "ContentInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "ContentInfoTableViewCell")
        tableView.register(UINib(nibName: "ContentDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "ContentDetailTableViewCell")
    }
    
    func loadImage(from urlString: String, into imageView: UIImageView) {
        guard let url = URL(string: urlString) else {
            imageView.image = nil
            return
        }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            } else {
                DispatchQueue.main.async {
                    imageView.image = nil
                }
            }
        }
    }
}

extension ContentTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch contentState {
        case .movie:
            return movies.count
        case .other:
            return movieList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch contentState {
        case .movie:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContentDetailTableViewCell", for: indexPath) as? ContentDetailTableViewCell else {
                return UITableViewCell()
            }
           
            cell.languageLabel.text = movies[indexPath.row].language
            cell.titleLabel.text = movies[indexPath.row].title
            cell.yearLabel.text = "Year: " + movies[indexPath.row].year
            loadImage(from: movies[indexPath.row].poster ?? "", into: cell.posterImageView)
            return cell
        case .other:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContentInfoTableViewCell", for: indexPath) as? ContentInfoTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.contentInfoValueLbl.text = movieList[indexPath.row].name
            cell.movies = movieList[indexPath.row].movie
            if movieList[indexPath.row].isExpanable {
                cell.tableViewHeightConstraint.constant = CGFloat(150 * movieList[indexPath.row].movie.count)
            } else {
                cell.tableViewHeightConstraint.constant = CGFloat(0)
            }
            cell.tableView.reloadData()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch contentState {
        case .movie:
            let selectedMovie = movies[indexPath.row]
                        delegate?.didSelectMovie(movie: selectedMovie)
                        
            break
        case .other:
            if movieList[indexPath.row].isExpanable {
                movieList[indexPath.row].isExpanable = false
            } else {
              
                movieList[indexPath.row].isExpanable = true
            }
            contentState = .other
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch contentState {
        case .movie:
            return 150
        case .other:
            if movieList[indexPath.row].isExpanable {
                return UITableView.automaticDimension
            } else {
                return 45
            }
        }
    }
    
    func getValuesMovie(movie: String, from movies: [Movie]) -> [Movie] {
        if let loadedMovies = loadMovies() {
            self.movies = loadedMovies
        }
        
        let lowercasedMovie = movie.lowercased()
        return self.movies.filter { movie in
            let titleMatches = movie.title.lowercased().contains(lowercasedMovie)
            let yearMatches = movie.year.lowercased().contains(lowercasedMovie)
            let directorMatches = movie.director.lowercased().contains(lowercasedMovie)
            let actorsMatch = movie.actors.lowercased().contains(lowercasedMovie)
            let genreMatches = movie.genre.lowercased().contains(lowercasedMovie)
            
            return titleMatches || yearMatches || directorMatches || actorsMatch || genreMatches
        }
    }
    
    func loadMovies() -> [Movie]? {
        if let url = Bundle.main.url(forResource: "movies", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let movies = try decoder.decode([Movie].self, from: data)
                return movies
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
        return nil
    }

}
extension ContentTableViewCell :ContentInfoTablewCellDelegate {
    func didSelectMovies(movie: Movie) {
        delegate?.didSelectMovie(movie: movie)
    }
    
}
