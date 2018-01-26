//
//  Alert.swift
//  swifty-companion
//
//  Created by Aymeric TOULOUSE on 1/25/18.
//  Copyright © 2018 Aymeric TOULOUSE. All rights reserved.
//

import UIKit

class Alert {
    func displayAlert(msg : String) {
        print("alert", msg)
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default))
        ViewController().present(alert, animated: true, completion: nil)
    }
}
