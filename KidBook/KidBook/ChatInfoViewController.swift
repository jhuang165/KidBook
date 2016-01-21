//
//  ChatInfoViewController.swift
//  KidBook
//
//  Created by programming-xcode on 1/10/16.
//  Copyright © 2016 programming-xcode. All rights reserved.
//

import UIKit

class ChatInfoViewController: UIViewController {
    
    @IBOutlet var username: UILabel!
    @IBOutlet var userpost: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        username.text = NSUserDefaults.standardUserDefaults().objectForKey("Username") as? String
        userpost.text = NSUserDefaults.standardUserDefaults().objectForKey("Text") as? String
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
