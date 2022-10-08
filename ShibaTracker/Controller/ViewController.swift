//
//  ViewController.swift
//  ShibaTracker
//
//  Created by Mac on 29.09.2022.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    var coinManager = CoinManager()
    
    let defaults = UserDefaults.standard

    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var coinView: UIView!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var shibaLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        checkNotificationsOn()
        checkNotificationAllow()
    }

    private func setupUI() {
        coinView.layer.cornerRadius = 15
        
}
    // MARK: - Local Notification
    
    @IBAction func notificationButton(_ sender: UIButton) {
    
        if sender.isSelected == true {
            sender.isSelected = false
            notificationButton.tintColor = UIColor.systemRed
            defaults.set(false, forKey: "Abc")
            createNotification()
        } else {
            sender.isSelected = true
            notificationButton.tintColor = UIColor.lightGray
            defaults.set(true, forKey: "Abc")
        }
    }
    
    private func createNotification() {
        //creating the notification content
        let content = UNMutableNotificationContent()

        //adding title,body and badge
        content.title = "Have you checked your Shiba Coin today?"
        content.body = "Enter the app to see how much your Shiba Coin is worth!"
        content.badge = 1

        //getting the notification trigger
        //it will be called after 5 seconds
        var dateInfo = DateComponents()
            dateInfo.hour = 19
            dateInfo.minute = 30
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)

        //getting the notification request
        let request = UNNotificationRequest(identifier: "SimplifiedIOSNotification", content: content, trigger: trigger)

        //adding the notification to notification center
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    private func checkNotificationAllow() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
            if error != nil {
                print(error)
            }
            else if error == nil, didAllow == true {
                print("No problem ")
            }
        })
    }
    
    private func checkNotificationsOn() {
        if defaults.bool(forKey: "Abc") == true {
            notificationButton.tintColor = UIColor.lightGray
        } else {
            notificationButton.tintColor = UIColor.systemRed
        }
    }

    }
    
//MARK: - UIPickerViewDataSource

extension ViewController: UIPickerViewDataSource {
func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
}

func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return coinManager.currencyArray.count
}
}

//MARK: - UIPickerViewDelegate

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
    }
}

//MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate {
    func didFailWithError(error: Error) {
        print (error)
    }
    
    func didUpdatePrice(price: String, currency: String) {
        DispatchQueue.main.async {
            self.shibaLabel.text = price
            self.currencyLabel.text = currency
           
        }
}
}




