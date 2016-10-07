//
//  QRReaderNavigationViewController.swift
//  TalCookie
//
//  Created by Tal Cohen on 10/7/16.
//  Copyright © 2016 Computer Science House. All rights reserved.
//

import UIKit

class QRReaderNavigationViewController: UINavigationController {

    var onDismiss: (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Pass along the function
        let qrReaderViewController = self.topViewController as! QRReaderViewController
        qrReaderViewController.onDismiss = self.onDismiss
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
