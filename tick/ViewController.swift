//
//  ViewController.swift
//  tick
//
//  Created by Martin Calvert on 6/8/18.
//  Copyright © 2018 Martin Calvert. All rights reserved.
//

import UIKit

class TickersViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        dateFormatter.timeZone = TimeZone.current
//        let tick = Ticker(date: dateFormatter.date(from: "2017-03-23")!)
        
    }
}

