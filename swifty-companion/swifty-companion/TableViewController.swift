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
    
    let consumerUid = "b51df73ce963e1aa3e8fcda6992ff013bdfc6e6bc2db8f48783ca3805d2a0eff"
    let consumerSecret = "c84e4596ea289c567db90f38996478dc5934539be2a4354d8b36162f820f6e19"
    var token = ""
    var users : [(Int, String, String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getToken()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UserCell

        cell.labelLogin.text = users[indexPath.row].1
        
        return cell
    }
    
    //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //    }
    
    func getToken() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let params = "grant_type=client_credentials&client_id=\(consumerUid)&client_secret=\(consumerSecret)"
        
        Alamofire.request("https://api.intra.42.fr/oauth/token?\(params)", method: .post).responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.token = json["access_token"] as! String
                    print("token==", self.token)
                }
            } else {
                DispatchQueue.main.async {
//                    self._alert(msg: (response.error as? String)!)
                }
            }
        }
        
    }

}

extension TableViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchBarText = searchController.searchBar.text else { return }
        if searchBarText == "" { return }

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.users = []

        let url = "https://api.intra.42.fr/v2/users?access_token=" + self.token + "&range[login]=" + searchBarText.lowercased() + ",z" + "&sort=login"
        
        Alamofire.request(url, method: .get).responseJSON { response in
            switch response.result {
            case .success(let res):
                print("res==", res)
                for user in res as! Array<Any> {
                    let json = JSON(user)
                    
                    let id = json["id"].int
                    let login = json["login"].string
                    let url = json["url"].string
                    self.users.append((id!, login!, url!))
                }
            case .failure(let error):
                print("failure==", error)
                // self._alert(msg: (response.error as? String)!)
            }
            self.tableView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}
