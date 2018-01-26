//
//  ViewController.swift
//  swifty-companion
//
//  Created by Aymeric TOULOUSE on 1/23/18.
//  Copyright © 2018 Aymeric TOULOUSE. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    var resultSearchController : UISearchController?
    var TableViewControllerDelegate : UITableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displaySearchBar()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "alliance_background")!)
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
    
        tableView.mainViewDelegate = self
    }
    
    func handleSegue(userId: String) {
        performSegue(withIdentifier: "segueViewToSecond", sender: userId)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueViewToSecond" {
            if let SecondViewController = segue.destination as? SecondViewController {
                SecondViewController.mainViewDelegate = self
                SecondViewController.userId = sender as? String
            }
        }
    }
    

}
