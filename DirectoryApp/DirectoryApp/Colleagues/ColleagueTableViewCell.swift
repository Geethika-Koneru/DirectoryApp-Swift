//
//  ColleagueTableViewCell.swift
//  DirectoryApp
//
//  Created by Geethika on 07/05/22.
//

import Foundation
import UIKit

struct ColleagueTableViewCellViewModel {
    let colleague: Colleague

    init(model: Colleague) {
        colleague = model
    }
}

class ColleagueTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var eMail: UILabel!
    @IBOutlet weak var favouriteColor: UILabel!

    var viewModel: ColleagueTableViewCellViewModel? {
        didSet {
            setUpColleagueData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        avatar.image = nil
        avatar.layer.cornerRadius = 10
    }
    
    func setUpColleagueData() {
        if let colleagueInfo = viewModel?.colleague {
            name.text = colleagueInfo.firstName + " " + colleagueInfo.lastName
            jobTitle.text = colleagueInfo.jobtitle
            eMail.text = colleagueInfo.email
            favouriteColor.text = colleagueInfo.favouriteColor
        }
    }
}

