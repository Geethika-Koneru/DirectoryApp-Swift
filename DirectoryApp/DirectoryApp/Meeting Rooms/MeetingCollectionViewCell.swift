//
//  MeetingCollectionViewCell.swift
//  DirectoryApp
//
//  Created by Geethika on 08/05/22.
//

import Foundation
import UIKit
class MeetingCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var meetingAvailability: UIImageView!
    @IBOutlet weak var meetingId: UILabel!
    @IBOutlet weak var occupancy: UILabel!
    
    var viewModel: MeetingTableViewCellViewModel? {
        didSet {
            setUpMeetingRoomData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {

    }
    
    func setUpMeetingRoomData() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.colorFrom(hex: brandColor).cgColor
        layer.cornerRadius = 10
        if let meetingRoomInfo = viewModel?.room {
            meetingId.text = "Meeting Room ID: "+meetingRoomInfo.id
            occupancy.text = String(meetingRoomInfo.maxOccupancy)
            meetingAvailability.backgroundColor = meetingRoomInfo.isOccupied ? .red : .green
            meetingAvailability.layer.cornerRadius = 5
        }
    }
}
