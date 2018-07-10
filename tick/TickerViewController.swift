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
    @IBOutlet weak var timePicker: UIDatePicker!
    var ticker: Ticker?
    
    @IBAction func clearIfName(_ sender: Any) {
        if (titleField.text == "Name") {
            titleField.text = ""
        }
    }
    @IBOutlet weak var dateField: UIButton!
    @IBOutlet weak var timeField: UIButton!
    @IBAction func loadDatePicker(_ sender: Any) {
        titleField.resignFirstResponder()
        timePicker.isHidden = true
        datePicker.isHidden = false
        
        datePickerChanged(sender: datePicker)
        
        datePicker.addTarget(self, action: #selector(datePickerChanged(sender:)), for: .valueChanged)
    }
    
    @IBAction func loadTimePicker(_ sender: Any) {
        datePicker.isHidden = true
        timePicker.isHidden = false
        
        datePickerChanged(sender: timePicker)
        
        timePicker.addTarget(self, action: #selector(datePickerChanged(sender:)), for: .valueChanged)
    }
    
    @objc func datePickerChanged(sender: UIDatePicker) {
        switch sender.datePickerMode {
        case .date:
            updateDateField(date: sender.date)
        case .time:
            updateTimeField(date: sender.date)
        default:
            print("wrong type")
        }
    }
    
    func updateDateField(date: Date) {
        UIView.performWithoutAnimation {
            dateField.setTitle(Ticker.dateFormatter.string(from: date), for: .normal)
            dateField.layoutIfNeeded()
        }
    }
    
    func updateTimeField(date: Date) {
        UIView.performWithoutAnimation {
            timeField.setTitle(Ticker.timeFormatter.string(from: date), for: .normal)
            timeField.layoutIfNeeded()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleField.delegate = self
        
        datePicker.setValue(UIColor.white, forKey: "textColor")
        datePicker.setValue(false, forKeyPath: "highlightsToday")
        datePicker.datePickerMode = .date
        
        timePicker.setValue(UIColor.white, forKey: "textColor")
        timePicker.setValue(false, forKeyPath: "highlightsToday")
        timePicker.datePickerMode = .time

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (ticker != nil) {
            updateUI()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.darkGray.cgColor
        let field = titleField!
        border.frame = CGRect(x: 0, y: field.frame.size.height - width, width: field.frame.size.width, height: field.frame.size.height)
        
        border.borderWidth = width
        
        field.layer.addSublayer(border)
        field.layer.masksToBounds = true
        
        [dateField, timeField].forEach { fields in
            let border = CALayer()
            let width = CGFloat(2.0)
            border.borderColor = UIColor.darkGray.cgColor
            let field = fields!
            border.frame = CGRect(x: 0, y: field.frame.size.height - width, width: field.frame.size.width, height: field.frame.size.height)
            
            border.borderWidth = width
            
            field.layer.addSublayer(border)
            field.layer.masksToBounds = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleField.resignFirstResponder()
        datePicker.isHidden = true
        timePicker.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: timePicker.date)
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: datePicker.date)
        
        dateComponents.hour = timeComponents.hour
        dateComponents.minute = timeComponents.minute
        
        self.ticker = Ticker(date: Calendar.current.date(from: dateComponents)!, name: titleField.text!)
    }
    
    private func updateUI() {
        titleField.text = ticker?.name
        updateDateField(date: (ticker?.date)!)
        updateTimeField(date: (ticker?.date)!)
        datePicker.date = (ticker?.date)!
        timePicker.date = (ticker?.date)!
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
