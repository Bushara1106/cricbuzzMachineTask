//
//  ContentInfoTableViewCell.swift
//  Movie_Task
//
//  Created by Bushara Siddiqui on 29/06/24.
//

import UIKit
protocol ContentInfoTablewCellDelegate: AnyObject {
    func didSelectMovies(movie: Movie)
}
class ContentInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var contentInfoValueLbl: UILabel!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    var movies: [Movie] = []
    weak var delegate: ContentInfoTablewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.dataSource = self
        tableView.delegate = self
        registerTableView()
    }
    @objc func selectionBtnTapped(_ sender: UIButton) {
        // Implement button tap action here
        guard let cell = sender.superview?.superview as? ContentDetailTableViewCell else {
            return
        }
        
        if let indexPath = tableView.indexPath(for: cell) {
            let selectedMovie = movies[indexPath.row]
            delegate?.didSelectMovies(movie: selectedMovie)
        }
    }
    func registerTableView() {
        tableView.register(UINib(nibName: "ContentTableViewCell", bundle: nil), forCellReuseIdentifier: "ContentTableViewCell")
        tableView.register(UINib(nibName: "ContentInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "ContentInfoTableViewCell")
        tableView.register(UINib(nibName: "ContentDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "ContentDetailTableViewCell")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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

extension ContentInfoTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContentDetailTableViewCell", for: indexPath) as? ContentDetailTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionBtn.addTarget(self, action: #selector(selectionBtnTapped(_:)), for: .touchUpInside)
        cell.languageLabel.text = movies[indexPath.row].language
        cell.titleLabel.text = movies[indexPath.row].title
        cell.yearLabel.text = "Year : " + movies[indexPath.row].year
        loadImage(from: movies[indexPath.row].poster ?? "", into: cell.posterImageView)
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            let selectedMovie = self.movies[indexPath.row]
            self.delegate?.didSelectMovies(movie: selectedMovie)
            tableView.reloadData()
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


