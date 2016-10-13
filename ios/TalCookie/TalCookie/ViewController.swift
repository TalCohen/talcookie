//
//  ViewController.swift
//  TalCookie
//
//  Created by Tal Cohen on 10/6/16.
//  Copyright © 2016 Computer Science House. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let registerURLString = "http://talcookie.app.csh.rit.edu/register/device"
    let errorString = "There was a problem with connecting to the Tal Cookie server. Please make sure you have an internet connection and try again."
    
    @IBOutlet weak var pairedLabel: UILabel!
    @IBOutlet weak var pairingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var pairButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        resetUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resetUI() {
        DispatchQueue.main.async {
            let defaults = UserDefaults.standard
            if defaults.bool(forKey: self.appDelegate.utilities.isPairedKey) {
                self.pairedLabel.text = "Device paired!"
                self.pairedLabel.textColor = #colorLiteral(red: 0.1628036319, green: 0.5, blue: 0.1818933694, alpha: 1)
            } else {
                self.pairedLabel.text = "Device not paired!"
                self.pairedLabel.textColor = #colorLiteral(red: 0.8370677348, green: 0.0269820736, blue: 0.1483354134, alpha: 1)
            }
            
            self.pairingActivityIndicator.stopAnimating()
            self.pairButton.isHidden = false
        }
    }

    @IBAction func pairButtonTapped(_ sender: AnyObject) {
        // Create a QR Code reader to pair the device
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let qrReaderNavigationViewController = storyboard.instantiateViewController(withIdentifier: "QRReaderNavigationViewController") as! QRReaderNavigationViewController
        
        // Attempt to pair the device on dismiss
        qrReaderNavigationViewController.onDismiss = self.pairDevice
        
        present(qrReaderNavigationViewController, animated: true)
    }
    
    func pairDevice() {
        // Reset isPaired
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: self.appDelegate.utilities.isPairedKey)
        
        // Change the UI
        DispatchQueue.main.async {
            self.pairedLabel.text = "Pairing device..."
            self.pairedLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.pairingActivityIndicator.startAnimating()
            self.pairButton.isHidden = true
        }
        
        // Get the data needed
        let ios = true
        guard let clientId = defaults.string(forKey: appDelegate.utilities.clientIdKey),
            let deviceToken = defaults.string(forKey: appDelegate.utilities.deviceTokenKey) else {
            appDelegate.notificationManager.registerForPushNotifications(application: UIApplication.shared, viewController: self)
            resetUI()
            return
        }
        
        // Make the request
        var request = URLRequest(url: URL(string: registerURLString)!)
        request.httpMethod = "POST"
        let postString = "client_id=\(clientId)&device_token=\(deviceToken)&ios=\(ios)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error with request: \(error)")
                self.resetUI()
                self.handlePairingError(vc: self, message: self.errorString)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                self.resetUI()
                self.handlePairingError(vc: self, message: self.errorString)
                return
            }
            
            do {
                let res = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                if let success = res["success"] as? Bool {
                    if (success) {
                        defaults.set(true, forKey: self.appDelegate.utilities.isPairedKey)
                    } else {
                        self.handlePairingError(vc: self, message: res["message"] as! String)
                    }
                }
            } catch let error as NSError {
                print("Unable to parse JSON response: \(error)")
            }
            
            self.resetUI()
        }
        task.resume()
    }
    
    func handlePairingError(vc: ViewController, message: String) {
        // Create and present an alert
        let alert = UIAlertController(title: "Unable to pair device", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let retryAction = UIAlertAction(title: "Retry", style: .default, handler: { (tryAgain) in
            self.pairDevice()
        })
        alert.addAction(cancelAction)
        alert.addAction(retryAction)
        alert.preferredAction = retryAction
        
        vc.present(alert, animated: true, completion: nil)
    }
}

