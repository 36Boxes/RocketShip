//
//  LeaderboardCell.swift
//  RocketShip
//
//  Created by Josh Manik on 27/05/2021.
//

import UIKit

class LeaderboardCell: UITableViewCell {
    
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var score: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
