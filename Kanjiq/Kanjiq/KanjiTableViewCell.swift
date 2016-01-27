//
//  KanjiTableViewCell.swift
//  Kanjiq
//
//  Created by Andrew Spencer on 1/27/16.
//  Copyright © 2016 Andrew Spencer. All rights reserved.
//

import UIKit

class KanjiTableViewCell: UITableViewCell {

    @IBOutlet weak var kanjiTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
