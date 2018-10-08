//
//  TickersTableViewController.swift
//  tick
//
//  Created by Martin Calvert on 6/11/18.
//  Copyright © 2018 Martin Calvert. All rights reserved.
//

import UIKit
import UserNotifications

class TickersTableViewController: UITableViewController {
    var tickers = [Ticker]() {
        didSet {
            setupNotifications()
        }
    }
    private var timer: Timer?
    private var intervalSeconds: Double?
    private var selectedTicker: Ticker?

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

        tableView.dataSource = self
        tableView.delegate = self

        self.intervalSeconds = 20.0
        setTimer()
    }

    func setupNotifications() {
        //Scheduling the Notification
        let center = UNUserNotificationCenter.current()

        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()

        for ticker in tickers {
            let content = UNMutableNotificationContent()
            content.title = ticker.name
            content.body = "It is time!"
            content.sound = UNNotificationSound.default

            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: ticker.date)

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

            let request = UNNotificationRequest(identifier: "REMINDER", content: content, trigger: trigger)

            center.add(request) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        save()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        selectedTicker = nil
        if (timer?.isValid)! == false {
            setTimer()
        }
    }

    // MARK: - Segues

    @IBAction func unwwindFromNew(_ sender: UIStoryboardSegue) {
        if let senderVC = sender.source as? TickerViewController {
            if selectedTicker == nil {
                tickers.append(senderVC.ticker!)
            } else {
                if let index = tickers.index(of: selectedTicker!) {
                    tickers[index] = senderVC.ticker!
                    selectedTicker = nil
                }
            }

            self.tableView.reloadData()
            save()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? TickerViewController {
            dvc.ticker = selectedTicker
        }
    }

    // MARK: - Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myId", for: indexPath)
        if let tickerCell = cell as? TickerTableViewCell {
            print(tickers[indexPath.row].color)
            tickerCell.ticker = tickers[indexPath.row]

            tickerCell.backgroundColor = UIColor(named: (tickerCell.ticker?.color)!)
            if Constants.whiteText.contains((tickerCell.ticker?.color)!) {
                tickerCell.date.textColor = UIColor.white
                tickerCell.timeTill.textColor = UIColor.white
                tickerCell.label.textColor = UIColor.white
            } else {
                tickerCell.date.textColor = UIColor.black
                tickerCell.timeTill.textColor = UIColor.black
                tickerCell.label.textColor = UIColor.black
            }

            if (tickerCell.ticker?.date.seconds(from: Date()))! < 60, (tickerCell.ticker?.date.seconds(from: Date()))! > -60 {
                intervalSeconds = 1.0
                setTimer()
            }

            return tickerCell
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

        }
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
            self.tickers.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.save()
        }

        let share = UITableViewRowAction(style: .default, title: "Edit") { (_, indexPath) in
            self.selectedTicker = self.tickers[indexPath.row]
            self.performSegue(withIdentifier: "edit", sender: self)
        }

        share.backgroundColor = UIColor.blue

        return [delete, share]
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
        timer = Timer.scheduledTimer(withTimeInterval: intervalSeconds!, repeats: true) { [weak self] _ in
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
            if currentIntervals != self?.intervalSeconds {
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
