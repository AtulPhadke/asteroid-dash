//
//  JoinPartyTableViewCell.swift
//  scibowl
//
//  Created by Atul Phadke on 11/14/20.
//

import UIKit

class JoinPartyTableViewCell: UITableViewCell {

    @IBOutlet var playerText: UILabel!
    
    @IBOutlet var astronaut: UIImageView!
    
    @IBOutlet var teamNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
