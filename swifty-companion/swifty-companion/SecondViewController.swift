//
//  SecondViewController.swift
//  swifty-companion
//
//  Created by Aymeric TOULOUSE on 1/23/18.
//  Copyright © 2018 Aymeric TOULOUSE. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SecondViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var mainViewDelegate : ViewController?
    var userId : String?
    var skills : Array<Any> = []
    var projects : Array<Any> = []
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var skillsTableView: UITableView!
    @IBOutlet weak var projectsTableView: UITableView!
    
    @IBOutlet weak var labelLogin: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelMobile: UILabel!
    @IBOutlet weak var labelLevel: UILabel!
    @IBOutlet weak var progressLevel: UIProgressView!
    @IBOutlet weak var labelPlace: UILabel!
    @IBOutlet weak var labelWallet: UILabel!
    @IBOutlet weak var labelCorrection: UILabel!
    @IBOutlet weak var viewPhoto: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "alliance_background")!)
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 4
        scrollView.zoomScale = 1
        scrollView.contentSize = (view?.frame.size)!
        scrollView.bounces = false
        
        skillsTableView.layer.cornerRadius = 10
        projectsTableView.layer.cornerRadius = 10
        
        getUserData()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return view
    }

    func getUserData() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
       
        let url = "https://api.intra.42.fr//v2/users/\(userId!)?access_token=\(secretData.token)"
        Alamofire.request(url).responseJSON { response in
            switch response.result {
            case .success(let res):
                let json = JSON(res)
                if let err = json["message"].string {
                    print("err==", err)
                    if err == "The access token expired" {
                        Token().getToken()
                        self.getUserData()
                    }
                    return
                }
                print("user==", json)
                if let login = json["login"].string {
                    self.labelLogin.text = login
                }
                if let name = json["displayname"].string {
                    self.labelName.text = name
                }
                if let email = json["email"].string {
                    self.labelEmail.text = email
                }
                if let mobile = json["phone"].string {
                    self.labelMobile.text = mobile
                } else {
                    self.labelMobile.text = "Phone hidden"
                }
                if let level = json["cursus_users"][0]["level"].float {
                    self.labelLevel.text = "Level " + String(describing: level)
                    self.progressLevel.progress = level.truncatingRemainder(dividingBy: 1)
                }
                if let wallet = json["wallet"].int {
                    self.labelWallet.text = "Wallet: \(wallet)"
                }
                if let correctionPoints = json["correction_point"].int {
                    self.labelCorrection.text = "Correction points: \(correctionPoints)"
                }
                if let place = json["location"].string {
                    self.labelPlace.text = place
                    self.labelPlace.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                } else {
                    self.labelPlace.text = "Unavailable"
                    self.labelPlace.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                }
                if let url = json["image_url"].url {
                    if let data = try? Data(contentsOf: url) {
                        self.viewPhoto.image = UIImage(data: data)
                    } else {
                        self.viewPhoto.image = UIImage(named: "default-user-image")
                    }
                }
                
                if let projects = json["projects_users"].array {
                    self.projects = projects
                }
                if let skills = json["cursus_users"][0]["skills"].array {
                    self.skills = skills
                }
            case .failure(let error):
                print("failure", error)
            }
            self.skillsTableView.reloadData()
            self.projectsTableView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView.restorationIdentifier == "skillsTableView" {
            return "Skills"
        } else {
            return "Projects"
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.restorationIdentifier == "skillsTableView" {
            return self.skills.count
        } else {
            return self.projects.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.restorationIdentifier == "skillsTableView" {
            let cell = skillsTableView.dequeueReusableCell(withIdentifier: "skillCell") as! SkillsCell

            let item = JSON(self.skills[indexPath.row])
            if let skillLevel = item["level"].float {
                cell.progressSkill.progress = skillLevel.truncatingRemainder(dividingBy: 1)
            }
            cell.labelSkill.text = item["name"].string

            return cell
            
        } else {
            let cell = projectsTableView.dequeueReusableCell(withIdentifier: "projectCell") as! ProjectsCell
            
            let item = JSON(self.projects[indexPath.row])
            let note = item["final_mark"].int
            if note != nil && note! > 0 {
                cell.labelProject.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                cell.labelProject.text = item["project"]["name"].string! + " \(note!)"
            } else if note != nil && note! == 0 {
                cell.labelProject.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                cell.labelProject.text = item["project"]["name"].string! + " \(note!)"
            } else {
                cell.labelProject.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.labelProject.text = item["project"]["name"].string! + " register"
            }

            
            return cell
        }
    }

}
