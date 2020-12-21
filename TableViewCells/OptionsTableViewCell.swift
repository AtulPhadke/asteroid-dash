//
//  OptionsTableViewCell.swift
//  scibowl
//
//  Created by Atul Phadke on 11/7/20.
//

import UIKit

class OptionsTableViewCell: UITableViewCell {

    @IBOutlet var categoryLabel: UILabel!
    
    var StepperValue = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //withOrWithoutCategory.selectedSegmentIndex = 0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
