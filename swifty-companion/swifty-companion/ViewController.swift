//
//  ViewController.swift
//  swifty-companion
//
//  Created by Aymeric TOULOUSE on 1/23/18.
//  Copyright © 2018 Aymeric TOULOUSE. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    var resultSearchController : UISearchController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        displaySearchBar()
    }
    
    func displaySearchBar() {
        let tableView = storyboard!.instantiateViewController(withIdentifier: "tableViewController") as! TableViewController
        resultSearchController = UISearchController(searchResultsController: tableView)
        resultSearchController?.searchResultsUpdater = tableView
        
        let searchBar = resultSearchController?.searchBar
        searchBar?.placeholder = "Search 42 student"
        searchBar?.sizeToFit()
        
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
    }
    
    func _alert(msg : String) {
        print("alert", msg)
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default))
        self.present(alert, animated: true, completion: nil)
    }
}
