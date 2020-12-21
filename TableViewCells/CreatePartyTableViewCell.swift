//
//  CreatePartyTableViewCell.swift
//  scibowl
//
//  Created by Atul Phadke on 10/10/20.
//

import UIKit
import SwiftyGif

class CreatePartyTableViewCell: UITableViewCell {

    @IBOutlet var playerUsername: UILabel!
    
    @IBOutlet var teamNumberLabel: UILabel!
    
    @IBOutlet var astronaut: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //playerUsername.text = ""
        self.backgroundColor = UIColor.clear
        self.teamNumberLabel.textAlignment = .right
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
