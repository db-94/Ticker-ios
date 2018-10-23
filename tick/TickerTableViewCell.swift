//
//  TickerTableViewCell.swift
//  tick
//
//  Created by Martin Calvert on 6/18/18.
//  Copyright © 2018 Martin Calvert. All rights reserved.
//

import UIKit

class TickerTableViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var timeTill: UILabel!
    @IBOutlet weak var date: UILabel!
    var thing: String?

    public var ticker: Ticker? {
        didSet {
            updateUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.contentView.bounds = self.bounds
        updateUI()
        // Configure the view for the selected state
    }

    public func updateUI() {
        if ticker != nil {
            label.text = ticker?.name
            timeTill.text = ticker?.timeTill
            date.text = ticker?.dateTimeString
        }
    }
}
