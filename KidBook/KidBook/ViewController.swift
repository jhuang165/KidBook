//
//  ViewController.swift
//  KidBook
//
//  Created by programming-xcode on 12/4/15.
//  Copyright © 2015 programming-xcode. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var signupActive = true
    
    @IBOutlet var username: UITextField!
    
    @IBOutlet var password: UITextField!
    
    @IBOutlet var reenterpassword: UITextField!
    
    @IBOutlet var signupButton: UIButton!
    
    @IBOutlet var loginButton: UIButton!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func signUp(sender: AnyObject) {
        
        if username.text == "" || password.text == "" {
            
            displayAlert("Error", message: "Please enter a username and password")
            
        } else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            var errorMessage = "Please try again later"
            
            if signupActive == true {
                reenterpassword.hidden = false
                let user = PFUser()
                user.username = username.text
                user.password = password.text
                
                
                if reenterpassword.text == password.text {
                    user.signUpInBackgroundWithBlock({ (success, error) -> Void in
                        
                        self.activityIndicator.stopAnimating()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        
                        if error == nil {
                            self.performSegueWithIdentifier("login", sender: self)
                        } else {
                            
                            if let errorString = error!.userInfo["error"] as? String {
                                
                                errorMessage = errorString
                                
                            }
                            
                            self.displayAlert("Failed SignUp", message: errorMessage)
                            
                        }
                        
                    })
                } else {
                    displayAlert("Failed SignUp", message: "The passwords do not match")
                }
                
            } else {
                PFUser.logInWithUsernameInBackground(username.text!, password: password.text!, block: { (user, error) -> Void in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if user != nil {
                        self.performSegueWithIdentifier("login", sender: self)
                    } else {
                        
                        if let errorString = error!.userInfo["error"] as? String {
                            
                            errorMessage = errorString
                            
                        }
                        
                        self.displayAlert("Failed Login", message: errorMessage)
                        
                    }
                    
                })
                
            }
            
        }
        
        
        
    }
    
    
    @IBAction func logIn(sender: AnyObject) {
        
        if signupActive == true {
            
            reenterpassword.hidden = true

            signupButton.setTitle("Log In", forState: UIControlState.Normal)
            
            loginButton.setTitle("Sign Up", forState: UIControlState.Normal)
            
            signupActive = false
            
        } else {
            
            reenterpassword.hidden = false
            
            signupButton.setTitle("Sign Up", forState: UIControlState.Normal)
            
            loginButton.setTitle("Log In", forState: UIControlState.Normal)
            
            signupActive = true
            
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        username.resignFirstResponder()
        password.resignFirstResponder()
        reenterpassword.resignFirstResponder()
    }
}

