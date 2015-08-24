//
//  ParseHelper.swift
//  Tomorrow
//
//  Created by Jason Noah Choi on 8/24/15.
//  Copyright (c) 2015 Jason Choi. All rights reserved.
//

import UIKit
import Crashlytics

private let _ParseHelperSharedInstance = ParseHelper()

class ParseHelper: NSObject {

    class var sharedInstance: ParseHelper {
        return _ParseHelperSharedInstance
    }

    func login(username:String, password:String, completionHandler: (success:Bool, message:String) -> ()) {
        PFUser.logInWithUsernameInBackground(username, password: password) { (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                println("Login successful")
                completionHandler(success: true, message: "")
            }else{
                var parseErrorMessage:String = error!.userInfo?["error"] as! String
                completionHandler(success: false, message: parseErrorMessage)
            }
        }
    }

    func register(email:String, password:String, phoneNumber: String, completionHandler: (success:Bool, message: NSString) -> ()) {
        var newUser:PFUser = PFUser()
        var emailLowercase = email.lowercaseString
        newUser.email = emailLowercase
        newUser.password = password
        newUser.setObject(phoneNumber, forKey: "phoneNumber")

        newUser.signUpInBackgroundWithBlock{ (success:Bool, error:NSError?) -> Void in
            if let error = error {
                let parseErrorMessage = error.userInfo?["error"] as? NSString
                completionHandler(success: false, message: parseErrorMessage! as NSString)
            }else{
                println("Sign up successful")
                Crashlytics.sharedInstance().setUserEmail(emailLowercase)
                completionHandler(success: true, message: "")
            }
        }
    }

   
}
