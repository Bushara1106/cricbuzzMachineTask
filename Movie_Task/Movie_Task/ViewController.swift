//
//  ViewController.swift
//  Movie_Task
//
//  Created by Bushara Siddiqui on 29/06/24.
//

import UIKit
enum MovieSection : String {
    case year = "Year"
    case genre = "Genre"
    case directors = "Directors"
    case actors = "Actors"
    case allMovie = "All Movies"
}

class ViewController: UIViewController {
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var movieDatabaseLbl: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
   
   
    var movieSection: [MovieSection] = [.year, .genre, .directors, .actors, .allMovie]
    var isExpanded: [Bool] = [Bool](repeating: false, count: 5)
    var contentState : ContentState = .other
    var filteredMovies: [Movie] = []
    var movies: [Movie] = []
    var movieList = [MovieList]()
    var year = [MovieList]()
    var actor = [MovieList]()
    var gen = [MovieList]()
    var dictor = [MovieList]()
    var tempYear = [MovieList]()
    var tempActor = [MovieList]()
    var tempDic = [MovieList]()
    var tempGen = [MovieList]()

    var isSearchActive: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        registerTableView()
        populateData()
      
    }
    func populateData(){
        let loadedData = loadMoviesList()
        if let loadedMovies = loadedData.0 {
            movies = loadedMovies
        }
        year = loadedData.1
        actor = loadedData.2
        dictor = loadedData.3
        gen = loadedData.4
    }
    func filterMovie(section:MovieSection){
        switch section {
        case .year:
            movieList = year
            break
        case .genre:
            movieList = gen
            break
        case .directors:
            movieList = dictor
            break
        case .actors:
            movieList = self.actor
            break
        case .allMovie:
            break
        }
    }
    
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieSection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContentTableViewCell", for: indexPath) as? ContentTableViewCell else {
               return UITableViewCell()
           }
           cell.delegate = self
           cell.contentTypeLbl.text = movieSection[indexPath.row].rawValue

           // Set the correct movieList based on whether search is active or not
           switch movieSection[indexPath.row] {
           case .year:
               movieList = isSearchActive ? tempYear : year
           case .genre:
               movieList = isSearchActive ? tempGen : gen
           case .directors:
               movieList = isSearchActive ? tempDic : dictor
           case .actors:
               movieList = isSearchActive ? tempActor : actor
           case .allMovie:
               // For All Movies section, handle as needed
               break
           }

           cell.movies = isSearchActive ? filteredMovies : movies
           cell.contentState = contentState
           cell.movieList = movieList

           // Adjust tableViewHeightConstraint based on expansion state and content type
           if isExpanded[indexPath.row] {
               switch contentState {
               case .movie:
                   cell.tableViewHeightConstraint.constant = CGFloat(160 * (isSearchActive ? filteredMovies.count : movies.count))
               case .other:
                   cell.tableViewHeightConstraint.constant = 500
               }
           } else {
               cell.tableViewHeightConstraint.constant = 0
           }

           cell.tableView.reloadData()
           return cell
       }


    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           // Toggle the expansion state for the selected row
           let isSelected = !isExpanded[indexPath.row]
           updateSelection(for: indexPath.row, isSelected: isSelected, tableView: tableView)

         
       }
    
    private func updateSelection(for row: Int, isSelected: Bool, tableView: UITableView) {
        isExpanded[row] = isSelected
        if movieSection[row].rawValue == "All Movies" {
            contentState = .movie
        } else {
            switch movieSection[row] {
            case .year:
                movieList = year
                
                break
            case .genre:
                movieList = gen
                
              
                break
            case .directors:
                movieList = dictor
                break
            case .actors:
                movieList = self.actor
                break
            case .allMovie:
                break
            }
            contentState = .other
            
        }
        
        DispatchQueue.main.async {
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isExpanded[indexPath.row] ? UITableView.automaticDimension : 50
    }
}
extension ViewController {
    func registerTableView() {
        tableView.register(UINib(nibName: "ContentTableViewCell", bundle: nil), forCellReuseIdentifier: "ContentTableViewCell")
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

extension ViewController{
    func loadMoviesList() -> ([Movie]?, [MovieList], [MovieList], [MovieList], [MovieList]) {
        var yearMovies = [MovieList]()
        var actorMovies = [MovieList]()
        var dictorMovies = [MovieList]()
        var genreMovies = [MovieList]()
        
        if let url = Bundle.main.url(forResource: "movies", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let movies = try decoder.decode([Movie].self, from: data)
                
                // Populate movies array
                self.movies = movies
                
                // Populate yearMovies
                let years = Array(Set(movies.map { $0.year })).sorted()
                for year in years {
                    let moviesOfYear = movies.filter { $0.year == year }
                    let yearMovie = MovieList(movie: moviesOfYear, name: year, isExpanable: false)
                    yearMovies.append(yearMovie)
                }
                
                // Populate actorMovies
                let actors = Array(Set(movies.flatMap { $0.actors.split(separator: ", ").map { String($0) } })).sorted()
                for actor in actors {
                    let moviesOfActor = movies.filter { $0.actors.lowercased().contains(actor.lowercased()) }
                    let actorMovie = MovieList(movie: moviesOfActor, name: actor, isExpanable: false)
                    actorMovies.append(actorMovie)
                }
                
                // Populate dictorMovies
                let directors = Array(Set(movies.map { $0.director })).sorted()
                for director in directors {
                    let moviesOfDirector = movies.filter { $0.director.lowercased().contains(director.lowercased()) }
                    let directorMovie = MovieList(movie: moviesOfDirector, name: director, isExpanable: false)
                    dictorMovies.append(directorMovie)
                }
                
                // Populate genreMovies
                let genres = Array(Set(movies.flatMap { $0.genre.split(separator: ", ").map { String($0) } })).sorted()
                for genre in genres {
                    let moviesOfGenre = movies.filter { $0.genre.lowercased().contains(genre.lowercased()) }
                    let genreMovie = MovieList(movie: moviesOfGenre, name: genre, isExpanable: false)
                    genreMovies.append(genreMovie)
                }
                
                return (movies, yearMovies, actorMovies, dictorMovies, genreMovies)
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
        return (nil, [], [], [], [])
    }
}
extension ViewController: ContentTableViewCellDelegate {
    func didSelectMovie(movie: Movie) {
        let storyboard = UIStoryboard(name: "RatingSourceViewController", bundle: nil)
        guard let ratingSourceVC = storyboard.instantiateViewController(withIdentifier: "RatingSourceViewController") as? RatingSourceViewController else {
            print("Unable to instantiate RatingSourceViewController from storyboard.")
            return
        }
        
        ratingSourceVC.modalPresentationStyle = .overFullScreen
        ratingSourceVC.plotText = movie.plot
        ratingSourceVC.posterImageText = movie.poster
        
        // Determine which rating source to display and set texts accordingly
        if let imdbRating = movie.imdbRating {
            ratingSourceVC.ratingLblText = "IMDB: \(imdbRating)"
        } else {
            ratingSourceVC.ratingLblText = "No IMDB rating available"
        }
        
        if let rottenTomatoesRating = movie.ratings.first(where: { $0.source == "Rotten Tomatoes" }) {
            ratingSourceVC.rottenLblText = "Rotten Tomatoes: \(rottenTomatoesRating.value)"
        } else {
            ratingSourceVC.rottenLblText = "No Rotten Tomatoes rating available"
        }
        
        if let metacriticRating = movie.ratings.first(where: { $0.source == "Metacritic" }) {
            ratingSourceVC.MetacriticValueText = "Metacritic: \(metacriticRating.value)"
        } else {
            ratingSourceVC.MetacriticValueText = "No Metacritic rating available"
        }
        
        ratingSourceVC.releasedLblText = movie.released
        ratingSourceVC.titleLblText = movie.title
        ratingSourceVC.genreLblText = movie.genre
        
        present(ratingSourceVC, animated: true, completion: nil)
    }
}
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearchActive = false
            movieSection = [.year, .genre, .directors, .actors, .allMovie]
            populateData()
            isExpanded = [Bool](repeating: false, count: 5)
        } else {
            isSearchActive = true
            let lowercasedMovie = searchText.lowercased()
            movieSection = []
            filteredMovies = movies.filter { movie in
                let titleMatches = movie.title.lowercased().contains(lowercasedMovie)
                let yearMatches = movie.year.lowercased().contains(lowercasedMovie)
                let directorMatches = movie.director.lowercased().contains(lowercasedMovie)
                let actorsMatch = movie.actors.lowercased().contains(lowercasedMovie)
                let genreMatches = movie.genre.lowercased().contains(lowercasedMovie)
                
                if titleMatches {
                    if !movieSection.contains(.allMovie) {
                        movieSection.append(.allMovie)
                    }
                }
                if genreMatches {
                    if !movieSection.contains(.genre) {
                        movieSection.append(.genre)
                    }
                }
                if actorsMatch {
                    if !movieSection.contains(.actors)  {
                        movieSection.append(.actors)
                    }
                }
                if directorMatches {
                    if !movieSection.contains(.directors) {
                        movieSection.append(.directors)
                    }
                }
                if yearMatches {
                    if !movieSection.contains(.year) {
                        movieSection.append(.year)
                    }
                }
                
                return titleMatches || genreMatches || actorsMatch || directorMatches || yearMatches
            }
            filterMovieList(filteredMovies: filteredMovies, text: lowercasedMovie)
        }
        tableView.reloadData()
    }
    
    func filterMovieList(filteredMovies: [Movie], text: String) {
        let lowercasedText = text.lowercased()
        
        // Reset temporary arrays to original values
        tempYear = year
        tempActor = self.actor
        tempDic = dictor
        tempGen = gen
        
        // Filter tempYear based on name matching search text
        tempYear = year.filter { movieList in
            movieList.name.lowercased().contains(lowercasedText)
        }
        
        // Filter tempActor based on name matching search text
        tempActor = self.actor.filter { movieList in
            movieList.name.lowercased().contains(lowercasedText)
        }
        
        // Filter tempDic based on name matching search text
        tempDic = dictor.filter { movieList in
            movieList.name.lowercased().contains(lowercasedText)
        }
        
        // Filter tempGen based on name matching search text
        tempGen = gen.filter { movieList in
            movieList.name.lowercased().contains(lowercasedText)
        }
        
        tableView.reloadData()
    }
}
