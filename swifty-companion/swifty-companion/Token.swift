//
//  Token.swift
//  swifty-companion
//
//  Created by Aymeric TOULOUSE on 1/26/18.
//  Copyright © 2018 Aymeric TOULOUSE. All rights reserved.
//

import Alamofire

class Token {
    func getToken() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let params = "grant_type=client_credentials&client_id=\(secretData.consumerUid)&client_secret=\(secretData.consumerSecret)"
        
        Alamofire.request("https://api.intra.42.fr/oauth/token?\(params)", method: .post).responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    secretData.token = json["access_token"] as! String
                }
            } else {
                DispatchQueue.main.async {
                    Alert().displayAlert(msg: (response.error as? String)!)
                }
            }
        }
    }
}
