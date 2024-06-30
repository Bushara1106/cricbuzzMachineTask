//
//  ContentDetailTableViewCell.swift
//  Movie_Task
//
//  Created by Bushara Siddiqui on 29/06/24.
//

import UIKit

class ContentDetailTableViewCell: UITableViewCell {
 
    @IBOutlet weak var selectionBtn: UIButton!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
