//
//  TickerViewController.swift
//  tick
//
//  Created by Martin Calvert on 6/22/18.
//  Copyright © 2018 Martin Calvert. All rights reserved.
//

import UIKit

class TickerViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    var ticker: Ticker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleField.delegate = self
        datePicker.setValue(UIColor.white, forKey: "textColor")
        datePicker.setValue(false, forKeyPath: "highlightsToday")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleField.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.ticker = Ticker(date: datePicker.date, name: titleField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
