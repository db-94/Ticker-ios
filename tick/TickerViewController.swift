//
//  TickerViewController.swift
//  tick
//
//  Created by Martin Calvert on 6/22/18.
//  Copyright © 2018 Martin Calvert. All rights reserved.
//

import UIKit

class TickerViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Variables

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var tealButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    @IBOutlet weak var pinkButton: UIButton!
    @IBOutlet weak var blackButton: UIButton!
    @IBOutlet weak var dateField: UIButton!
    @IBOutlet weak var timeField: UIButton!
    var ticker: Ticker?
    private var color: String = Constants.teal.rawValue

    // MARK: - Title field methods

    @IBAction func clearIfName(_ sender: Any) {
        if titleField.text == "Name" {
            titleField.text = ""
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    // MARK: - Date & Time field methods

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
            print("Wrong type for datePickerMode")
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

    // MARK: - Color selection buttons

    @IBOutlet var colorButtons: [UIButton]!
    @IBAction func chooseColor(_ sender: UIButton) {
        colorButtons.forEach { colorButton in
            colorButton.isSelected = sender == colorButton
        }
        switch sender.titleLabel?.text! {
        case "Teal":
            color = Constants.teal.rawValue
        case "Black":
            color = Constants.black.rawValue
        case "Purple":
            color = Constants.purple.rawValue
        case "Pink":
            color = Constants.pink.rawValue
        default:
            break
        }
    }

    // MARK: - View Lifecycle methods

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if ticker != nil {
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

    func updateUI() {
        titleField.text = ticker?.name
        updateDateField(date: (ticker?.date)!)
        updateTimeField(date: (ticker?.date)!)
        datePicker.date = (ticker?.date)!
        timePicker.date = (ticker?.date)!
        switch ticker?.color {
        case Constants.teal.rawValue:
            tealButton.isSelected = true
        case Constants.purple.rawValue:
            purpleButton.isSelected = true
        case Constants.pink.rawValue:
            pinkButton.isSelected = true
        case Constants.black.rawValue:
            blackButton.isSelected = true
        default:
            break
        }
    }

    // MARK: - Segue Navigation methods

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: timePicker.date)
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: datePicker.date)

        dateComponents.hour = timeComponents.hour
        dateComponents.minute = timeComponents.minute

        self.ticker = Ticker(date: Calendar.current.date(from: dateComponents)!, name: titleField.text!, color: color)
    }
}
