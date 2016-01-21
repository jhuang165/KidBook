//
//  LoggedInViewController.swift
//  KidBook
//
//  Created by programming-xcode on 12/7/15.
//  Copyright © 2015 programming-xcode. All rights reserved.
//

import UIKit 
import Parse
import Bolts

class LoggedInViewController: UIViewController, UITableViewDelegate {
    
    
    var data:[[String:String]] = []
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var userChat: UITextField!
    @IBOutlet var chatWith: UITextField!
    var chattingWith = false
    var refresher: UIRefreshControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            _ = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "update", userInfo: nil, repeats: true)
            
            self.refresher = UIRefreshControl()
            
            self.refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
            
            self.refresher.addTarget(self, action: "update", forControlEvents: UIControlEvents.ValueChanged)
            
            self.tableView.addSubview(self.refresher)
            
            self.update()
        }
    }
    
    func update() {
        let query = PFQuery(className: "Chat")
        query.limit = 100000000000000000
        let objects = try! query.findObjects()
        data = []
        for i in objects {
            var finalDictionary: [String: String] = [:]
            finalDictionary["username"] = i.objectForKey("username")! as? String
            finalDictionary["text"] = i.objectForKey("text")! as? String
            if chattingWith {
                if i.objectForKey("username")! as! String == chatWith.text! && i.objectForKey("to")! as? String == PFUser.currentUser()?.username || i.objectForKey("username")! as? String == PFUser.currentUser()?.username && i.objectForKey("to")! as! String == chatWith.text! {
                    data.append(finalDictionary)
                }
            } else {
                if i.objectForKey("to")! as! String == "" {
                    data.append(finalDictionary)
                }
            }
        }
        tableView.reloadData()
        refresher.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UserCell
        
        cell.username.text = data[indexPath.row]["username"]
        cell.userPost.text = data[indexPath.row]["text"]
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            if data[indexPath.row]["username"] == PFUser.currentUser()?.username {
                data.removeAtIndex(indexPath.row)
                update()
            }
        }
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("ChatInfo", sender: self)
        NSUserDefaults.standardUserDefaults().setObject(data[indexPath.row]["username"], forKey: "Username")
        NSUserDefaults.standardUserDefaults().setObject(data[indexPath.row]["text"], forKey: "Text")
    }
    
    @IBAction func send(sender: AnyObject) {
        let obj = PFObject(className: "Chat")
        obj.setObject((PFUser.currentUser()?.username)!, forKey: "username")
        obj.setObject(userChat.text!,forKey: "text")
        obj.setObject(chattingWith ? chatWith.text! : "", forKey: "to")
        try! obj.save()
        userChat.text = ""
        userChat.resignFirstResponder()
    }
    
    @IBAction func initiatePrivateChat() {
        chattingWith = !chattingWith
        chatWith.text = chattingWith ? chatWith.text! : ""
        userChat.resignFirstResponder()
    }
    
    @IBAction func Logout() {
        PFUser.logOut()
        self.performSegueWithIdentifier("Logout", sender: self)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        userChat.resignFirstResponder()
        chatWith.resignFirstResponder()
    }

}