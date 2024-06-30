//
//  RatingSourceViewController.swift
//  Movie_Task
//
//  Created by Bushara Siddiqui on 29/06/24.
//
import UIKit

class RatingSourceViewController: UIViewController {
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var plotLbl: UILabel!
    @IBOutlet weak var genreLbl: UILabel!
    @IBOutlet weak var releasedLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    
    @IBOutlet weak var imdbvalueLbl: UILabel!
    @IBOutlet weak var MetacriticValueLbl: UILabel!
    @IBOutlet weak var MetacriticLbl: UILabel!
    @IBOutlet weak var MetacritictoggleView: UIView!
    
    @IBOutlet weak var rottenLblValue: UILabel!
    @IBOutlet weak var rottentToggleView: UIView!
    @IBOutlet weak var rottentLbl: UILabel!
    @IBOutlet weak var ratingToggleView: UIView!
    
    @IBOutlet weak var heightConstantImdb: NSLayoutConstraint!
    
    @IBOutlet weak var heightConstantmeta: NSLayoutConstraint!
    @IBOutlet weak var heightConstantrottent: NSLayoutConstraint!
    var plotText: String?
    var genreLblText: String?
    var posterImageText: String?
    var ratingLblText: String?
    var MetacriticValueText: String?
    var rottenLblText: String?
    var titleLblText: String?
    var releasedLblText: String?
    
    var ratingViewVisible = false
    var rottentToggleViewVisible = false
    var MetacritictoggleViewVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        plotLbl.text = plotText
        genreLbl.text = genreLblText
        releasedLbl.text = releasedLblText
        titleLbl.text = titleLblText
        
        if let posterUrlString = posterImageText,
           let posterUrl = URL(string: posterUrlString) {
            loadImage(from: posterUrl, into: posterImage)
        } else {
            posterImage.image = UIImage(named: "default_poster") // Placeholder image or default image
        }
        
        ratingLbl.text = ratingLblText
        imdbvalueLbl.text = ratingLblText // Assuming this is the correct property
        MetacriticValueLbl.text = MetacriticValueText // Assuming this is the correct property
        rottenLblValue.text = rottenLblText // Assuming this is the correct property
        
        // Add tap gesture recognizers
        let ratingTapGesture = UITapGestureRecognizer(target: self, action: #selector(ratingLabelTapped))
        ratingLbl.isUserInteractionEnabled = true
        ratingLbl.addGestureRecognizer(ratingTapGesture)
        
        let metacriticTapGesture = UITapGestureRecognizer(target: self, action: #selector(MetacriticLblTapped))
        MetacriticLbl.isUserInteractionEnabled = true
        MetacriticLbl.addGestureRecognizer(metacriticTapGesture)
        
        let rottenTapGesture = UITapGestureRecognizer(target: self, action: #selector(rottentLblTapped))
        rottentLbl.isUserInteractionEnabled = true
        rottentLbl.addGestureRecognizer(rottenTapGesture)
        
        // Hide toggle views initially
        ratingToggleView.isHidden = true
        MetacritictoggleView.isHidden = true
        rottentToggleView.isHidden = true
        heightConstantImdb.constant = 0
        heightConstantmeta.constant = 0
        heightConstantrottent.constant = 0
    }
    
    @objc func ratingLabelTapped() {
        ratingViewVisible.toggle()
        updateHeightConstants()
        ratingToggleView.isHidden = !ratingViewVisible
    }
    
    @objc func MetacriticLblTapped() {
        MetacritictoggleViewVisible.toggle()
        MetacritictoggleView.isHidden = !MetacritictoggleViewVisible
        updateHeightConstants()
    }
    
    @objc func rottentLblTapped() {
        rottentToggleViewVisible.toggle()
        rottentToggleView.isHidden = !rottentToggleViewVisible
        updateHeightConstants()
    }
    
    @IBAction func cutBtn(_ sender: UIButton) {
        dismiss(animated: false)
    }
    
    func loadImage(from url: URL, into imageView: UIImageView) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }
    }
    func updateHeightConstants() {
            // Adjust the height constants based on visibility
            
            if ratingViewVisible {
                heightConstantImdb.constant = 60
            } else {
                heightConstantImdb.constant = 0
            }
            
            if MetacritictoggleViewVisible {
                heightConstantmeta.constant = 60
            } else {
                heightConstantmeta.constant = 0
            }
            
            if rottentToggleViewVisible {
            heightConstantrottent.constant = 60
            } else {
                heightConstantrottent.constant = 0
            }
            
            // Animate the height constraint changes
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    @IBAction func dropDownBtn(_ sender: UIButton) {
        ratingViewVisible.toggle()
        updateHeightConstants()
        ratingToggleView.isHidden = !ratingViewVisible
    }
    
    
    
   
    @IBAction func dropDownBtn2(_ sender: UIButton) {
        rottentToggleViewVisible.toggle()
        rottentToggleView.isHidden = !rottentToggleViewVisible
        updateHeightConstants()
    }
    
    
    
    @IBAction func dropDownBtn3(_ sender: UIButton) {
        MetacritictoggleViewVisible.toggle()
        MetacritictoggleView.isHidden = !MetacritictoggleViewVisible
        updateHeightConstants()
    }
    
    
}
