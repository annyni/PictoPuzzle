//
//  GalleryTableViewCell.swift
//  PictoPuzzle
//
//  Created by Anny Ni on 11/30/14.
//  Copyright (c) 2014 Anny Ni. All rights reserved.
//

import UIKit

class GalleryTableViewCell: UITableViewCell {

    @IBOutlet var galleryPuzzleView: UIImageView!
    
    @IBOutlet var puzzleNameLabel: UILabel!
    @IBOutlet var bestMovesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
