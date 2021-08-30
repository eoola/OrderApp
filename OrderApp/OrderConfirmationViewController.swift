//
//  OrderConfirmationViewController.swift
//  OrderApp
//
//  Created by Emmanuel Ola on 7/11/21.
//

import UIKit
import UserNotifications

class OrderConfirmationViewController: UIViewController {
    
    let minutesToPrepare: Int
    var timer: Timer?
    var timeLeft: Int
    let timerProgress: Progress
    
    init?(_ coder: NSCoder, minutesToPrepare: Int) {
        self.minutesToPrepare = minutesToPrepare
        self.timeLeft = (minutesToPrepare * 60) - 1
        self.timer = nil
        self.timerProgress = Progress(totalUnitCount: Int64(minutesToPrepare * 60))
        super.init(coder: coder)
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                self.scheduleNotification()
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet var confirmationLabel: UILabel!
    @IBOutlet var orderTimeLeftView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        confirmationLabel.text = "Thank you for your order! Your current wait time: \(minutesToPrepare):00"
        orderTimeLeftView.observedProgress = timerProgress
    }
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Your meal will be ready soon!"
        content.subtitle = "Get ready to pick up your order"
        content.sound = UNNotificationSound.default
        
        if (minutesToPrepare > 10) {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval((60 * (minutesToPrepare - (minutesToPrepare - 10)))), repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        } else {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval((60 * (minutesToPrepare / 2))), repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    @objc func updateTimer() {
        confirmationLabel.text = "Thank you for your order! Your current wait time: \(self.timeFormatted(timeLeft))"
        if timeLeft != 0 {
            timeLeft -= 1
            timerProgress.completedUnitCount += 1
        } else {
            if let timer = self.timer {
                timer.invalidate()
                self.timer = nil
                timerProgress.cancel()
            }
        }
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
