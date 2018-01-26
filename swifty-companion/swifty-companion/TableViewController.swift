//
//  TableViewController.swift
//  swifty-companion
//
//  Created by Aymeric TOULOUSE on 1/24/18.
//  Copyright © 2018 Aymeric TOULOUSE. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TableViewController: UITableViewController {
    
    var users : Array<Any> = []
    var mainViewDelegate : ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Token().getToken()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UserCell

        if users.count > 0 {
            let item = JSON(users[indexPath.row])
            if let userName = item["login"].string {
                cell.labelLogin.text = userName
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = JSON(users[indexPath.row])
        mainViewDelegate?.handleSegue(userId: String(describing: item["id"].int!))
        mainViewDelegate?.TableViewControllerDelegate = self
        dismiss(animated: true, completion: nil)
    }

}

extension TableViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchBarText = searchController.searchBar.text else { return }
        if searchBarText == "" { return }

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.users = []

        let url = "https://api.intra.42.fr/v2/users?access_token=" + secretData.token + "&range[login]=" + searchBarText.lowercased() + ",\(searchBarText.lowercased())z" + "&sort=login"
        
        Alamofire.request(url, method: .get).responseJSON { response in
            switch response.result {
            case .success(let res):
                let json = JSON(res)
                if let err = json["error"].string {
                    print("err==", err)
                    return
                }
                self.users = res as! Array
            case .failure(let error):
                print("failure==", error)
                // Alert().displayAlert(msg: (response.error as? String)!)
            }
            self.tableView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}
