//
//  SelectSetTableViewCell.swift
//  
//
//  Created by Atul Phadke on 11/16/20.
//

import UIKit

class SelectSetTableViewCell: UITableViewCell {
    
    @IBOutlet var set_label: UILabel!
    
    @IBOutlet var completed_label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
