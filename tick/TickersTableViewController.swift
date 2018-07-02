//
//  TickersTableViewController.swift
//  tick
//
//  Created by Martin Calvert on 6/11/18.
//  Copyright © 2018 Martin Calvert. All rights reserved.
//

import UIKit

class TickersTableViewController: UITableViewController {
    private var tickers = [Ticker]()
    private var timer: Timer?
    private var intervalSeconds: Double?
    
    // MARK: - View Controller Lifecycle

    /**
     Function flows as follows:
     1. Load items from disk.
     2. Setup naviagtion view controller items.
     3. Set table view source.
     4. Start the timers to update the UI.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = try? FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
            ).appendingPathComponent("user.json") {
            if let jsonData = try? Data(contentsOf: url) {
                if let arr = try? JSONDecoder().decode(Array<Ticker>.self, from: jsonData) {
                    self.tickers = arr
                }
            }
        }
        
        self.navigationItem.title = "Ticker"
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.dataSource = self
        
        self.intervalSeconds = 20.0
        setTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        save()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (timer?.isValid)! == false {
            setTimer()
        }
    }
    
    // MARK: - Segues
    
    @IBAction func unwwindFromNew(_ sender: UIStoryboardSegue) {
        if let senderVC = sender.source as? TickerViewController {
            tickers.append(senderVC.ticker!)
            self.tableView.reloadData()
            save()
        }
    }

    // MARK: - Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myId", for: indexPath)
        if let tickerCell = cell as? TickerTableViewCell {
            tickerCell.ticker = tickers[indexPath.row]
            
            if (tickerCell.ticker?.date.seconds(from: Date()))! < 60, (tickerCell.ticker?.date.seconds(from: Date()))! > -60 {
                intervalSeconds = 1.0
                setTimer()
            }
            
            return tickerCell
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.tickers.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            save()
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // MARK: - Helper Functions
    private func setTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: intervalSeconds!, repeats: true) { [weak self] timer in
            let currentIntervals = self?.intervalSeconds
            self?.intervalSeconds = 20.0
            self?.tableView.visibleCells.forEach { [weak self] cell in
                if let tickerCell = cell as? TickerTableViewCell {
                    if (tickerCell.ticker?.date.seconds(from: Date()))! < 60 && (tickerCell.ticker?.date.seconds(from: Date()))! > -60 {
                        self?.intervalSeconds = 1.0
                    }
                    tickerCell.updateUI()
                }
            }
            if (currentIntervals != self?.intervalSeconds) {
                self?.setTimer()
            }
        }
    }
    
    private func save() {
        let jsonData = try? JSONEncoder().encode(tickers)
        if let url = try? FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
            ).appendingPathComponent("user.json") {
            do {
                try jsonData?.write(to: url)
            } catch let error {
                print(error)
            }
        }
    }
}
