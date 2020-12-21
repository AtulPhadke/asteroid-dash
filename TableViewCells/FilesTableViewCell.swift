//
//  FilesTableViewCell.swift
//  scibowl
//
//  Created by Atul Phadke on 11/22/20.
//

import UIKit

class FilesTableViewCell: UITableViewCell {

    @IBOutlet var filesText: UILabel!
    
    @IBOutlet var iconImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
