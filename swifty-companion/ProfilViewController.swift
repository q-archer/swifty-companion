//
//  ProfilViewController.swift
//  swifty-companion
//
//  Created by Quentin ARCHER on 9/12/16.
//  Copyright © 2016 Quentin ARCHER. All rights reserved.
//

import UIKit

struct JsonData {
    var name: String
    var value: String
    var validated: Int
}

class ProfilViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var SkillView: UITableView!
    @IBOutlet weak var ProjectView: UITableView!
    @IBOutlet weak var ProfilImage: UIImageView!
    @IBOutlet weak var Level: UILabel!
    @IBOutlet weak var Email: UILabel!
    @IBOutlet weak var Phone: UILabel!
    @IBOutlet weak var Location: UILabel!
    @IBOutlet weak var CorrectionPoint: UILabel!
    @IBOutlet weak var Projects: UILabel!
    @IBOutlet weak var Skills: UILabel!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var login: String?
    var APIToken: String?
    var dataProject = [JsonData]()
    var dataSkill = [JsonData]()
    var test2 = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init label
        Level.layer.borderWidth = 0.2
        Level.layer.cornerRadius = 2
        Level.layer.masksToBounds = true
        Level.layer.borderColor = UIColor.lightGrayColor().CGColor
        Email.layer.borderWidth = 0.2
        Email.layer.cornerRadius = 2
        Email.layer.masksToBounds = true
        Email.layer.borderColor = UIColor.lightGrayColor().CGColor
        Phone.layer.borderWidth = 0.2
        Phone.layer.cornerRadius = 2
        Phone.layer.masksToBounds = true
        Phone.layer.borderColor = UIColor.lightGrayColor().CGColor
        Location.layer.borderWidth = 0.2
        Location.layer.cornerRadius = 2
        Location.layer.masksToBounds = true
        Location.layer.borderColor = UIColor.lightGrayColor().CGColor
        CorrectionPoint.layer.borderWidth = 0.2
        CorrectionPoint.layer.cornerRadius = 2
        CorrectionPoint.layer.masksToBounds = true
        CorrectionPoint.layer.borderColor = UIColor.lightGrayColor().CGColor
        Projects.layer.borderWidth = 0.2
        Projects.layer.cornerRadius = 2
        Projects.layer.masksToBounds = true
        Projects.layer.borderColor = UIColor.lightGrayColor().CGColor
        Skills.layer.borderWidth = 0.2
        Skills.layer.cornerRadius = 2
        Skills.layer.masksToBounds = true
        Skills.layer.borderColor = UIColor.lightGrayColor().CGColor
        ProfilImage.layer.borderWidth = 0.2
        ProfilImage.layer.borderColor = UIColor.lightGrayColor().CGColor
        ProfilImage.layer.cornerRadius = 75.0
        SkillView.layer.borderWidth = 0.2
        SkillView.layer.cornerRadius = 2
        SkillView.layer.masksToBounds = true
        SkillView.layer.borderColor = UIColor.lightGrayColor().CGColor
        ProjectView.layer.borderWidth = 0.2
        ProjectView.layer.cornerRadius = 2
        ProjectView.layer.masksToBounds = true
        ProjectView.layer.borderColor = UIColor.lightGrayColor().CGColor

        navigationItem.title = login
        
        // Init tableView
        ProjectView.dataSource = self
        ProjectView.delegate = self
        SkillView.dataSource = self
        SkillView.delegate = self
        
        // Get token and login data
        guard APIToken == nil else {
            checkToken({(token: String) in
                self.getData(token, login: self.login!)
            })
            return
        }
        getToken({(response: String) in
            self.APIToken = response
            if self.APIToken != nil {
                self.getData(self.APIToken!, login: self.login!)
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: ProjectView fct
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count: Int?
        
        if tableView == self.ProjectView {
            count = dataProject.count
        } else if tableView == self.SkillView {
            count = dataSkill.count
        }
        
        return count!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        
        if tableView == self.ProjectView {
            cell = tableView.dequeueReusableCellWithIdentifier("project", forIndexPath: indexPath)
            cell!.textLabel?.text = dataProject[indexPath.row].name
            cell!.detailTextLabel?.text = dataProject[indexPath.row].value
            if dataProject[indexPath.row].validated == 1 {
                cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
            else {
                cell!.accessoryType = UITableViewCellAccessoryType.None
            }
        } else if tableView == self.SkillView {
            cell = tableView.dequeueReusableCellWithIdentifier("skill", forIndexPath: indexPath)
            cell!.textLabel?.text = dataSkill[indexPath.row].name
            cell!.detailTextLabel?.text = dataSkill[indexPath.row].value
        }
        return cell!
    }
    
    // MARK: TOKEN fct
    
    func checkToken(completionHandler: (token: String) -> ()) -> Void {
        let getEndpoint: String = ("https://api.intra.42.fr/v2/users/qarcher?access_token=" + self.APIToken!)
        let url = NSURL(string: getEndpoint)
        let session = NSURLSession.sharedSession()
        session.dataTaskWithURL(url!, completionHandler:
            {( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                guard let realResponse = response as? NSHTTPURLResponse where
                    realResponse.statusCode == 200 else {
                        self.getToken({(response: String) in
                            completionHandler(token: response)
                        })
                        return
                }
                completionHandler(token: self.APIToken!)
        }).resume()
    }
    
    func getToken(completionHandler: (response: String) -> ()) {
        let postEndpoint: String = "https://api.intra.42.fr/oauth/token"
        let url = NSURL(string: postEndpoint)!
        let session = NSURLSession.sharedSession()
        let postParams : [String: AnyObject] = [
            "grant_type": "client_credentials",
            "client_id": "879d44e14c193144a1e51f48dfab96cafdd81c23c5b7d0a7c32d3aa9c14a1e5b",
            "client_secret": "8872216b000ae25eb761dce16f69b5fa6c967257fe8a998dae837d86e3bdb645"
        ]
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(postParams, options: NSJSONWritingOptions())
        } catch {
            print("ERROR POST 1")
        }
        let task = session.dataTaskWithRequest(request, completionHandler:
            {
                (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                
                guard let realResponse = response as? NSHTTPURLResponse where
                    realResponse.statusCode == 200 else {
                        print("We have a problem with our server. Please try again later.")
                        return
                }
                
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                    if let access_token = json["access_token"] as? String {
                        completionHandler(response: access_token)
                    }
                } catch {
                    print("ERROR POST 2")
                }
                
        })
        task.resume()
    }

    // MARK: data fct
    
    func getData(tok: String, login: String) -> Void {
        let getEndpoint: String = ("https://api.intra.42.fr/v2/users/" + login + "?access_token=" + tok)
        let url = NSURL(string: getEndpoint)
        //print(tok)
        //print(login)
        if url == nil {
            feedPage(nil)
            return
        }
        let session = NSURLSession.sharedSession()
        session.dataTaskWithURL(url!, completionHandler:
            {( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                
                let toto = response as? NSHTTPURLResponse
                //print(toto!.statusCode)
                // CATCH ERROR BAD LOGIN OR SERVER PROBLEM
                if toto!.statusCode != 200 {
                    print(error)
                }
                self.feedPage(data)
        }).resume()
    }

    func feedPage(data: NSData?)
    {
        dowloadImage()
        if data == nil {
            dispatch_async(dispatch_get_main_queue(), {
                self.Email.text = self.Email.text! + "None"
                self.Phone.text = self.Phone.text! + "None"
                self.Level.text = self.Level.text! + "None"
                self.Location.text = self.Location.text! + "None"
                self.CorrectionPoint.text = self.CorrectionPoint.text! + "None"
                self.blurView.hidden = true
                self.loadingIndicator.stopAnimating()
            })
            return 
        }
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            //print(json)
            var realEmail: String?
            var realPhone: String?
            var realLevel: String?
            var realLocation: String?
            var realPoint: String?
            
            if let testEmail = json["email"] as? String {
                realEmail = testEmail
            } else {
                realEmail = "None"
            }
            if let testPhone = json["phone"] as? String {
                realPhone = testPhone
            } else {
                realPhone = "None"
            }
            if let cursus = json["cursus_users"] as? [[String: AnyObject]] {
                if let testLevel = cursus[0]["level"] as? Float {
                    realLevel = String(testLevel)
                }
                else {
                    realLevel = "None"
                }
                if let testSkill = cursus[0]["skills"] as? [[String: AnyObject]] {
                    for s in testSkill {
                        var nameSkill = s["name"] as? String
                        if nameSkill == nil {
                            nameSkill = ""
                        }
                        var levelSkill = s["level"] as? Float
                        if levelSkill == nil {
                            levelSkill = 0.0
                        }
                        dataSkill.append(JsonData(name: nameSkill!, value: String(levelSkill!), validated: 0))
                    }
                }
            }
            else {
                realLevel = "None"
            }
            if let testLocation = json["location"] as? String {
                realLocation = testLocation
            } else {
                realLocation = "None"
            }
            if let testPoint = json["correction_point"] as? Int {
                realPoint = String(testPoint)
            } else {
                realPoint = "None"
            }
            if let testProject = json["projects_users"] as? [[String: AnyObject]] {
                for p in testProject {
                    let status = p["status"] as? String
                    if status == "finished" {
                        var tmp_name = p["project"]!["name"] as? String
                        if tmp_name == nil {
                            tmp_name = ""
                        }
                        var tmp_mark = p["final_mark"] as? Int
                        if tmp_mark == nil {
                            tmp_mark = 0
                        }
                        let valid = p["validated?"] as? Bool
                        var realValid: Int
                        if valid == nil || valid == false {
                            realValid = 0
                        }
                        else {
                            realValid = 1
                        }
                        let tmp = JsonData(name: tmp_name!, value: String(tmp_mark!), validated: realValid)
                        dataProject.append(tmp)
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.Email.text = self.Email.text! + realEmail!
                self.Phone.text = self.Phone.text! + realPhone!
                self.Level.text = self.Level.text! + realLevel!
                self.Location.text = self.Location.text! + realLocation!
                self.CorrectionPoint.text = self.CorrectionPoint.text! + realPoint!
                self.ProjectView.reloadData()
                self.SkillView.reloadData()
                self.blurView.hidden = true
                self.loadingIndicator.stopAnimating()
            })
        } catch {
            dispatch_async(dispatch_get_main_queue(), {
                self.Email.text = self.Email.text! + "None"
                self.Phone.text = self.Phone.text! + "None"
                self.Level.text = self.Level.text! + "None"
                self.Location.text = self.Location.text! + "None"
                self.CorrectionPoint.text = self.CorrectionPoint.text! + "None"
                self.blurView.hidden = true
                self.loadingIndicator.stopAnimating()
            })
        }
    }
    
    func dowloadImage() {
        let getEndPoint = ("https://cdn.intra.42.fr/users/medium_" + self.login! + ".jpg")
        let url = NSURL(string: getEndPoint)
        if url == nil {
            self.ProfilImage.image = UIImage(named: "noPicture")
            return
        }
        let session = NSURLSession.sharedSession()
        session.dataTaskWithURL(url!, completionHandler:
            {( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                if let realResponse = response as? NSHTTPURLResponse {
                    if realResponse.statusCode != 200 {
                        self.ProfilImage.image = UIImage(named: "noPicture")
                        return
                    }
                }
                else {
                    self.ProfilImage.image = UIImage(named: "noPicture")
                    return
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.ProfilImage.image = UIImage(data: data!)
                })
        }).resume()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
