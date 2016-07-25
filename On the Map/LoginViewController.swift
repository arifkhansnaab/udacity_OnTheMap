//
//  ViewController.swift
//  On the Map
//
//  Created by Arif Khan on 4/25/16.
//  Copyright © 2016 Snnab. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var labelLoginError: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func authenticateUser(sender: AnyObject) {
        
        var strError : String
        strError = ""
        if ( txtEmail.text?.isEmpty == true) {
             strError = "Email"
             strError +=  "\r\n"
        }

        if ( txtPassword.text?.isEmpty == true)  {
            strError += "Password"
            strError +=  "\r\n"
        }
        
        if (!strError.isEmpty) {
            var finalMessage = "Please enter below fields \r\n"
            finalMessage += strError
            self.labelLoginError.text = finalMessage
            
            self.displayMessage("Required Data Alert", message: finalMessage)
            return
        }
 
        
        let oAuthenticationManager = AuthenticationManager()
        
        oAuthenticationManager.Authenticate(txtEmail.text!, password:txtPassword.text!) {
            (oLoggedInUser:LoggedInUser) ->() in
            
            if ( oLoggedInUser.loginError.characters.count > 0 ) {
                self.displayMessage("Login error", message: oLoggedInUser.loginError)
            }
            
            oAuthenticationManager.HydrateUser(oLoggedInUser.userId) {
                (oLoggedInUser:LoggedInUser) ->() in
                
                if ( oLoggedInUser.loginError.characters.count > 0 ) {
                    self.displayMessage("Login error", message: oLoggedInUser.loginError)
                }
                LoggedInUserManager.loggedInUser = oLoggedInUser
            
                if ( oLoggedInUser.userId.characters.count > 0 ) {
                    NSOperationQueue.mainQueue().addOperationWithBlock {
                        self.performSegueWithIdentifier("launchMapSegue", sender: self)
                    }
                }
            
            }
            
        }
        
    }
}







