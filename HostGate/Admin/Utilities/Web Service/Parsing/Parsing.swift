//
//  Parsing.swift
//  Receipt Catcher
//
//  Created by tarun-mac-6 on 04/03/19.
//  Copyright © 2019 Tarun Nagar. All rights reserved.
//

import UIKit
import MobileCoreServices
class Parsing: NSObject,URLSessionDelegate {
    

    //MARK: SignUp API ---- SignUpViewController
    func postRequest(_ postString: String?, request method: String?, completion completionBlock: @escaping (_ result: [AnyHashable: Any]?) -> Void) {
        
        
        let Parameter = String(format: "%@%@", Config().API_URL,method!)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        request.httpBody = postString?.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            var jsonResult  = NSDictionary()
            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
            
            var status = Int()
            status = jsonResult.object(forKey: "status") as! Int
            
            if status==1
            {
                completionBlock(jsonResult as? [AnyHashable : Any])
            }
            else
            {
                print("Error")
            }
            print("jsonResult: \(jsonResult)")
            
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RegistrationOTP"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
        }
        task.resume()
        
    }
    
    
    //MARK:- HostGates Login
    func HostGateLogin(Language:String!,Username:String!,Password:String!,Role_Id:Int!,DeviceType:String!,Device_ID:String!,device_id:NSString!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_Login)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        
        
    let postString = String(format: "language=%@&username=%@&password=%@&role_id=%d&device_type=%@&device_id=%@&device_id=%@",Language,Username,Password,Role_Id,DeviceType,Device_ID,device_id)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateLoginNotification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
          
        }
        task.resume()
    }

    
    //MARK:- HostGates User Login
    func HostGateUserLogin(Language:String!,Country:String!,Community:String!,Username:String!,Password:String!,Role_Id:Int!,DeviceType:String!,Device_ID:String!,device_id:NSString!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_Login)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        
        
        let postString = String(format: "language=%@&country=%@&community=%@&username=%@&password=%@&role_id=%d&device_type=%@&device_id=%@&device_id=%@",Language,Country,Community,Username,Password,Role_Id,DeviceType,Device_ID,device_id)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateUserLoginNotification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    //MARK:- HostGates Gate Login
    func HostGateGteLogin(Language:String!,Country:String!,Community:String!,Username:String!,Password:String!,Role_Id:Int!,DeviceType:String!,Device_ID:String!,device_id:NSString!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_Login)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        
        
        let postString = String(format: "language=%@&country=%@&community=%@&username=%@&password=%@&role_id=%d&device_type=%@&device_id=%@&device_id=%@",Language,Country,Community,Username,Password,Role_Id,DeviceType,Device_ID,device_id)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateGteLoginNotification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
   
    
    //MARK:- HostGate Verification
    func HostGatesVerification(Language:String!,UserId:Int!,OTP:String!,RoleId:Int!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_VerifyOtp)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&user_id=%d&otp=%@&role_id=%d",Language,UserId,OTP,RoleId)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateVerificationNotification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    //MARK:- Discover Verification
    func HostGateForgotUserNamePassword(Language:String!,Email:String!,Type:String!,RoleId:Int!,Country:String!,Community:String!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_ForgotNamePasword)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%d&email=%@&type=%@&role_id=%d&country=%@&community=%@",Language,Email,Type,RoleId,Country,Community)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateForgotUsernamePassword"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
 
    
    
    //MARK:- HostGate Reset Password
    func HostGateResetPassword(Langauge:String!,UserId:Int!,NewPassword:String!,RoleId:Int!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_ResetPassword)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&user_id=%d&password=%@&role_id=%d",Langauge,UserId,NewPassword,RoleId)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateResetPasswordNotification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    //MARK:- HostGate Resend OTP
    func HostGateResendotp(Language:String!,UserId:Int!,RoleId:Int!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_ResendOtp)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&user_id=%d&role_id=%d",Language,UserId,RoleId)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateResendOtpNotification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
   
    //MARK:- HostGate Logout
       func HostGatesLogout(UserId:Int!,RoleId:Int!){
           let API_Path = "\(Config().API_URL)"
           let API_Method = "\(Config().API_Logout)"
           
           let Parameter = String(format: "%@%@", API_Path,API_Method)
           
           var request = URLRequest(url: URL(string: Parameter)!)
           request.httpMethod = "POST"
           
           let postString = String(format: "user_id=%d&role_id=%d",UserId,RoleId)
           
           request.httpBody = postString.data(using: .utf8)
           let task = URLSession.shared.dataTask(with: request) { data, response, error in
               guard let data = data, error == nil else {
                   
                   // check for fundamental networking error
                   print("error=\(String(describing: error))")
                   return
               }
               if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                   print("statusCode should be 200, but is \(httpStatus.statusCode)")
                   print("response = \(String(describing: response))")
                   return
               }
               
               let responseString = String(data: data, encoding: .utf8)
               print("responseString = \(String(describing: responseString))")
               
               if let httpResponse = response as? HTTPURLResponse {
                   if httpResponse.statusCode != 200 {
                       SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                   }else {
                       
                       DispatchQueue.main.async() {
                           if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                               var jsonResult: NSDictionary?
                               jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                               print("jsonResult: \(String(describing: jsonResult ?? nil))")
                               NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGatesLogoutNotification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                           }else {
                               SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                           }
                       }
                   }
               }
               
               
           }
           task.resume()
       }
       
      
       
    
    
    
    /// MARK: --- User Profile Detail API ---
    func HostGateUserDetail(Language:String!,user_Id: Int!,RoleId:Int!) {
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_GetUserProfile)"
        
        let Parameter = String(format: "%@%@",API_Path,API_Method)
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&user_id=%d&role_id=%d",Language,user_Id,RoleId)
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
                
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult  = NSDictionary()
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            print("jsonResult: \(jsonResult)")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostgateUserDetail"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    //MARK:- HostGate Change Password
    func HostGateChangePassword(Language:String!,UserId:Int!,OldPassword:String!,NewPassword:String!,RoleId:Int!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_ChangePassword)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&user_id=%d&current_password=%@&password=%@&role_id=%d",Language,UserId,OldPassword,NewPassword,RoleId)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateChangePasswordNotification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    //MARK:- HostGate Dashboard
    func HostGateDashboard(Language:String!,UserId:Int!,RoleId:Int!,AdminUserID:Int!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_Dashboard)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&user_id=%d&role_id=%d&admin_user_id=%d",Language,UserId,RoleId,AdminUserID)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateDashboardNotification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    
    //MARK:- HostGate Dashboard
    func HostGateDashboard1(Language:String!,UserId:Int!,RoleId:Int!,AdminUserID:Int!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_Dashboard)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&user_id=%d&role_id=%d&admin_user_id=%d",Language,UserId,RoleId,AdminUserID)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateDashboard1Notification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    //MARK:- HostGate Dashboard
    func HostGateDashboard2(Language:String!,UserId:Int!,RoleId:Int!,AdminUserID:Int!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_Dashboard)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&user_id=%d&role_id=%d&admin_user_id=%d",Language,UserId,RoleId,AdminUserID)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateDashboard2Notification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    //MARK:- HostGate Resend OTP
    func HostGateGetBusinessDetail(Language:String!,UserId:Int!,RoleId:Int!,AdminUserID:Int!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_getBusinessDetail)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&user_id=%d&role_id=%d&admin_user_id=%d",Language,UserId,RoleId,AdminUserID)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateGetBusinessDetail"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    //MARK:- HostGate Community Get
    func HostGateGetCommunityData(Language:String!,CommunityId:Int!,RoleId:Int!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_GetCommunityData)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&community_id=%d&role_id=%d",Language,CommunityId,RoleId)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateGetCommunityData"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    
    //MARK:- HostGate All Community 
    func HostGateGetAllCommunity(Language:String!,UserId:Int!,RoleId:Int!,AdminUserID:Int!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_GetAllCommunity)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&user_id=%d&role_id=%d&admin_user_id=%d",Language,UserId,RoleId,AdminUserID)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateGetAllCommunity"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    
    //MARK:- HostGate Resend OTP
    func HostGateDeleteCommunity(Language:String!,CommunityId:Int!,UniqueName:String!,RoleId:Int!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_DeleteCommunity)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&community_id=%d&unique_name=%@&role_id=%d",Language,CommunityId,UniqueName,RoleId)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateDeleteCommunity"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    //MARK:- HostGate Send Message
    func HostGateSendMessage(Language:String!,Message:String!,PropertyArray:String!,RoleId:Int!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_SendMessage)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&message=%@&user_property_ids=%@&role_id=%d",Language,Message,PropertyArray,RoleId)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateSendMessage"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    
    //MARK:- HostGate Create Support tickets
    func HostGateCreateSupportTickets(Language:String!,UserId:Int!,RoleId:Int!,TicketsNumber:String!,Subject:String!,Reason:String!,Role:Int!,AdminId:Int!,community:Int!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_CreateSupportTickets)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&user_id=%d&role_id=%d&ticket_number=%@&subject=%@&reason=%@&role=%d&admin_user_id=%d&community_id=%d",Language,UserId,RoleId,TicketsNumber,Subject,Reason,Role,AdminId,community)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateCreateSupportTickets"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    
    //MARK:- HostGate Add Subscription Plan
    func HostGateAddSubscriptionPlan(Language:String!,UserId:Int!,RoleId:Int!,AdminUserid:Int!,Usernumber:String!,Duration:Int!,TotalAmount:Float!,AutoRenewel:Int!,CounpenId:Int!,OrderID:String!,transationid:Int!,PtToken:String!,ptcusemail:String!,ptcutomerPass:String!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_AddSubscriptionPlan)"
        
        
       // coupon_id, order_id, transaction_id, pt_token, pt_customer_email, pt_customer_password, language
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&user_id=%d&role_id=%d&admin_user_id=%d&user_number=%@&duration=%d&total_amount=%f&auto_renewal=%d&coupon_id=%d&order_id=%@&transaction_id=%d&pt_token=%@&pt_customer_email=%@&pt_customer_password=%@",Language,UserId,RoleId,AdminUserid,Usernumber,Duration,TotalAmount,AutoRenewel,CounpenId,OrderID,transationid,PtToken,ptcusemail,ptcutomerPass)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateAddSubscriptionPlan"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    //MARK:- HostGate Subscription List
    func HostGateSubscriptionList(Language:String!,UserId:Int!,RoleId:Int!,AdminUserid:Int!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_SubscriptionList)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&user_id=%d&role_id=%d&admin_user_id=%d",Language,UserId,RoleId,AdminUserid)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateSubscriptionList"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    //MARK:- HostGate VisitorTypes List
    func HostGateVisitorTypeList(Language:String!,UserId:Int!,RoleId:Int!,AdminUserid:Int!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_VisitorTypeList)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&user_id=%d&role_id=%d&admin_user_id=%d",Language,UserId,RoleId,AdminUserid)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateVisitorTypeList"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    
    //MARK:- HostGate Add VisitorTypes
    func HostGateAddVisitorType(Language:String!,UserId:Int!,RoleId:Int!,AdminUserid:Int!,Type:String!,CommunityType:Int!,type_ar:String!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_AddVisitors)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&user_id=%d&role_id=%d&admin_user_id=%d&type=%@&community_type=%d&type_ar=%@",Language,UserId,RoleId,AdminUserid,Type,CommunityType,type_ar)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateAddVisitorType"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    //MARK:- HostGate Get VisitorTypes
    func HostGateGetVisitorType(Language:String!,UserId:Int!,RoleId:Int!,AdminUserid:Int!,TypeId:Int!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_GetVisitorTypes)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&user_id=%d&role_id=%d&admin_user_id=%d&type_id=%d",Language,UserId,RoleId,AdminUserid,TypeId)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateGetVisitorType"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    
    //MARK:- HostGate Update VisitorTypes
    func HostGateUpdateVisitorType(Language:String!,UserId:Int!,RoleId:Int!,AdminUserid:Int!,TypeId:Int!,Type:String!,type_ar:String!,community_type:Int!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_UpdateVisitorType)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&user_id=%d&role_id=%d&admin_user_id=%d&type_id=%d&type=%@&type_ar=%@&community_type=%d",Language,UserId,RoleId,AdminUserid,TypeId,Type,type_ar,community_type)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateUpdateVisitorType"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    ///Get Reason Detail----
    func GetPriceData(){
        
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_GetPrice)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "GET"
        
        let postString = String(format: "")
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            // else {
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            var jsonResult  = NSDictionary()
            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
            print("jsonResult: \(jsonResult)")
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GetPriceData"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
            //  }
        }
        task.resume()
    }
    
    //MARK:- HostGate Delete VisitorTypes
    func HostGateDeleteVisitorType(Language:String!,TypeId:Int!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_DeleteVisitorType)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&type_id=%d",Language,TypeId)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateDeleteVisitorType"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    //MARK:- HostGate Auto Renewal
    func HostGateUpdateAutoRenewal(Language:String!,UserId:Int!,RoleId:Int!,AdminUserid:Int!,Subscription_id:Int!,Auto_Renewal:Int!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_UpdateAutorenewal)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&user_id=%d&role_id=%d&admin_user_id=%d&subscription_id=%d&auto_renewal=%d",Language,UserId,RoleId,AdminUserid,Subscription_id,Auto_Renewal)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateUpdateAutoRenewal"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    
    
    ///Get Country List----
    func GetCountryList(){
        
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_GetCountry)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "")
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            // else {
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            var jsonResult  = NSDictionary()
            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
            print("jsonResult: \(jsonResult)")
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GetCountryListNotification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
            //  }
        }
        task.resume()
    }
    
    
    
    //MARK:- HostGate Sub-Account List
    func HostGateSubaccountList(Language:String!,UserId:Int!,RoleId:Int!,AdminUserid:Int!,SearchKeyword:String!,CommunityID:Int!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_SunAccountList)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&user_id=%d&role_id=%d&admin_user_id=%d&search_keyword=%@&community_id=%d",Language,UserId,RoleId,AdminUserid,SearchKeyword,CommunityID)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateSubaccountList"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    //MARK:- UserAccountDetails
    func UserAccountDetailsList(PropertyId:String!,CommunityType:String!){
           let API_Path = "\(Config().API_URL)"
           let API_Method = "\(Config().API_UserAccountDetails)"
           
           let Parameter = String(format: "%@%@", API_Path,API_Method)
           
           var request = URLRequest(url: URL(string: Parameter)!)
           request.httpMethod = "POST"
           
           let postString = String(format: "property_id=%@&community_type=%@",PropertyId,CommunityType)
           
           request.httpBody = postString.data(using: .utf8)
           let task = URLSession.shared.dataTask(with: request) { data, response, error in
               guard let data = data, error == nil else {
                   
                   // check for fundamental networking error
                   print("error=\(String(describing: error))")
                   return
               }
               if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                   print("statusCode should be 200, but is \(httpStatus.statusCode)")
                   print("response = \(String(describing: response))")
                   return
               }
               
               let responseString = String(data: data, encoding: .utf8)
               print("responseString = \(String(describing: responseString))")
               
               if let httpResponse = response as? HTTPURLResponse {
                   if httpResponse.statusCode != 200 {
                       SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                   }else {
                       
                       DispatchQueue.main.async() {
                           if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                               var jsonResult: NSDictionary?
                               jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                               print("jsonResult: \(String(describing: jsonResult ?? nil))")
                               NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserAccountDetailsList"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                           }else {
                               SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                           }
                       }
                   }
               }
               
               
           }
           task.resume()
       }
    
    //MARK:- HostGate Get Sub-Account
    func HostGateGetSubaccount(Language:String!,UserId:Int!,RoleId:Int!,AdminUserid:Int!,SubAccountID:Int!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_GetSubAccount)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&user_id=%d&role_id=%d&admin_user_id=%d&subaccount_id=%d",Language,UserId,RoleId,AdminUserid,SubAccountID)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateGetSubaccount"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    //MARK:- HostGate Delete Sub-Account
    func HostGateDeleteSubaccount(Language:String!,SubAccountId:Int!,UniqueName:String!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_DeleteSubAccount)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&subaccount_id=%d&unique_name=%@",Language,SubAccountId,UniqueName)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateDeleteSubaccount"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    
    //MARK:- HostGate VisitorsTypeListbyUserId
    func HostGateVisitorsTypeListbyUserId(Language:String!,UserId:Int!,RoleId:Int!,AdminUserid:Int!,CommunityID:Int!,Role:Int!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_VisitorTypeListByUserID)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&user_id=%d&role_id=%d&admin_user_id=%d&community_id=%d&role=%d",Language,UserId,RoleId,AdminUserid,CommunityID,Role)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateVisitorsTypeListbyUserId"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    //MARK:- HostGate User Visitors Record List
    func HostGateUserVisitorsRecordList(Language:String!,UserId:Int!,RoleId:Int!,AdminUserid:Int!,SearchKeyword:String!,Role:Int!,Visitor_Sorting:String!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_UserVisitorList)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&user_id=%d&role_id=%d&admin_user_id=%d&search_keyword=%@&role=%d&visitor_sorting=%@",Language,UserId,RoleId,AdminUserid,SearchKeyword,Role,Visitor_Sorting)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateUserVisitorsRecordList"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    //MARK:- HostGate User Add Visitors Record
    func HostGateUserAddVisitorsRecord(Language:String!,UserId:Int!,RoleId:Int!,AdminUserid:Int!,CommunityID:Int!,Role:Int!,Visitor_Type_Id:Int!,Name:String!,Date1:String!,Time:String!,Count:String!,VisName:String!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_UserAddVisitors)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&user_id=%d&role_id=%d&admin_user_id=%d&community_id=%d&role=%d&visitor_type_id=%d&name=%@&date=%@&time=%@&count=%@&name=%@",Language,UserId,RoleId,AdminUserid,CommunityID,Role,Visitor_Type_Id,Name,Date1,Time,Count,VisName)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateUserAddVisitorsRecord"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    //MARK:- HostGate User Update Visitors Record
    func HostGateUserUpdateVisitorsRecord(Language:String!,UserId:Int!,RoleId:Int!,AdminUserid:Int!,CommunityID:Int!,Role:Int!,Visitor_Type_Id:Int!,Name:String!,Date1:String!,Time:String!,Count:String!,Visitor_Id:Int!,VisName:String!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_UserUpdateVisitors)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&user_id=%d&role_id=%d&admin_user_id=%d&community_id=%d&role=%d&visitor_type_id=%d&name=%@&date=%@&time=%@&count=%@&visitor_id=%d&name=%@",Language,UserId,RoleId,AdminUserid,CommunityID,Role,Visitor_Type_Id,Name,Date1,Time,Count,Visitor_Id,VisName)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateUserUpdateVisitorsRecord"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    //MARK:- HostGate User Get Visitors Record
    func HostGateUserGetVisitorsRecord(Language:String!,UserId:Int!,RoleId:Int!,AdminUserid:Int!,Role:Int!,Visitor_Id:Int!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_UserGetVisitors)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&user_id=%d&role_id=%d&admin_user_id=%d&role=%d&visitor_id=%d",Language,UserId,RoleId,AdminUserid,Role,Visitor_Id)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateUserGetVisitorsRecord"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    //MARK:- HostGate User Delete Visitors Record
    func HostGateUserDeleteVisitorsRecord(Language:String!,VisitorId:Int!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_UserDeleteVisitors)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&visitor_id=%d",Language,VisitorId)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateUserDeleteVisitorsRecord"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    //MARK:- HostGate User Accept Reject Visitors
    func HostGateUserAcceptRejectVisitors(Language:String!,VisitorId:Int!,Status:Int!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_AcceptRejectVisitor)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&visitor_id=%d&status=%d",Language,VisitorId,Status)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateUserAcceptRejectVisitors"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    //MARK:- HostGate User Cancle Visitors Record
    func HostGateUserCancleVisitorsRecord(Language:String!,VisitorId:Int!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_UserCancleVisitors)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&visitor_id=%d",Language,VisitorId)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateUserCancleVisitorsRecord"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    //MARK:- HostGate Send Otp Visitors
    func HostGateUserSendOtpVisitors(Language:String!,VisitorId:Int!,CountryCode:String!,Phone:String!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_UserSendOtpVisitors)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&visitor_id=%d&country_code=%@&phone=%@",Language,VisitorId,CountryCode,Phone)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateUserSendOtpVisitors"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    //MARK:- HostGate User Host Pass
    func HostGateUserHostPass(Language:String!,UserId:Int!,RoleId:Int!,AdminUserid:Int!,Role:Int!,Community_Id:Int!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_UserHostPass)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&user_id=%d&role_id=%d&admin_user_id=%d&role=%d&community_id=%d",Language,UserId,RoleId,AdminUserid,Role,Community_Id)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateUserHostPass"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    
    //MARK:- HostGate Download Invoice
    func HostGateDownloadInvoice(Language:String!,UserId:Int!,RoleId:Int!,AdminUserID:Int!,SunscrtionId:Int!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_DownloadInvoice)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&user_id=%d&role_id=%d&admin_user_id=%d&subscription_id=%d",Language,UserId,RoleId,AdminUserID,SunscrtionId)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateDownloadInvoice"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    
    //MARK:- HostGate Apply Coupen
    func HostGateApplyCoupen(Language:String!,UserId:Int!,UserNumber:Int!,Coupen:String!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_ApplyCoupen)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&user_id=%d&user_number=%d&coupon=%@",Language,UserId,UserNumber,Coupen)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateApplyCoupen"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    
    
    
    //MARK:- HostGate Subscription Renew
    func HostGateRenewSubstription(Language:String!,SubscriptionId:Int!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_RenewSubscription)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&subscription_id=%d",Language,SubscriptionId)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateRenewSubstription"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    
    //MARK:- HostGate Verify Payment Renew
    func  HostGateVerifyRenewPayment(Language:String!,SubscriptionId:Int!,OrderID:String!,TranstionId:Int!,PtTocken:String!,PtEmail:String!,PtPass:String!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_VerifyRenewPayment)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
     //   subscription_id, order_id, transaction_id, pt_token, pt_customer_email, pt_customer_password,  language
        
        let postString = String(format: "language=%@&subscription_id=%d&order_id=%@&transaction_id=%d&pt_token=%@&pt_customer_email=%@&pt_customer_password=%@",Language,SubscriptionId,OrderID,TranstionId,PtTocken,PtEmail,PtPass)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateVerifyRenewPayment"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    
    
    
    // MARK: Update Subaccount
    func HostGatesUpdateSubAccount(data: UpdateSubAccountModel){
        let parameters = [
            "user_id" : data.UserId,
            "role_id": data.RoleId,
            "admin_user_id" : data.AdminUserId,
            "subaccount_id":data.SubAccounbtID,
            "community_id" : data.CommunityID,
            "name" : data.Name,
            "country_code" : data.Countrycode,
            "phone" : data.Mobilenumber,
            "country_id_number" : data.Country_Id_Number,
            "id_number": data.Id_Number,
            "email":data.Email,
            "language":data.Language
            ] as [String : Any]
        
        print(parameters)
        // build your dictionary however appropriate
        
        let boundary = generateBoundaryString()
        
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_UpdateSubAccount)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try createBodyWithParameters(parameters: parameters, filePathKey: "profile_picture", imageData: data.profile_picture, imageName: "ProfilePicture.png", filePathKey1: "proof_id", imageData1: data.IDProof, imageName1: "IDProofPicture.png", boundary: boundary) as Data
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
                
            else {
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
                do {
                    
                    var jsonResult  = NSDictionary()
                    jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                    print("jsonResult: \(jsonResult)")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGatesUpdateSubAccount"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                    
                } catch let error as NSError {
                    print(error)
                    //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignUpTutor"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                    // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignUpTutor"), object: nil)
                }
            }
        }
        task.resume()
    }
    
    
    
    
    // MARK: Add Subaccount
    func HostGatesAddSubAccount(data: AddSubaccountsModel){
        let parameters = [
            "user_id" : data.UserId,
            "role_id": data.RoleId,
            "admin_user_id" : data.AdminUserId,
            "community_id" : data.CommunityID,
            "name" : data.Name,
            "country_code" : data.Countrycode,
            "phone" : data.Mobilenumber,
            "country_id_number" : data.Country_Id_Number,
            "id_number": data.Id_Number,
            "email":data.Email,
            "unique_name":data.Unique_Name,
            "password":data.Password,
            "language":data.Language
            ] as [String : Any]
        
        print(parameters)
        // build your dictionary however appropriate
        
        let boundary = generateBoundaryString()
        
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_AddSubAccount)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try createBodyWithParameters(parameters: parameters, filePathKey: "profile_picture", imageData: data.profile_picture, imageName: "ProfilePicture.png", filePathKey1: "proof_id", imageData1: data.IDProof, imageName1: "IDProofPicture.png", boundary: boundary) as Data
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
                
            else {
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
                do {
                    
                    var jsonResult  = NSDictionary()
                    jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                    print("jsonResult: \(jsonResult)")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGatesAddSubAccount"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                    
                } catch let error as NSError {
                    print(error)
                    //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignUpTutor"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                    // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignUpTutor"), object: nil)
                }
            }
        }
        task.resume()
    }
    
    
    
    
    
    // MARK: Update Profile
    func HostGatesUpdateCommunity(data: UpdateCommunityModel){
        let parameters = [
            "community_id" : data.CommunityID,
            "title": data.CommunityTitle,
            "unique_name" : data.CommunityUniqueName,
            "type" : data.CommunityType,
            "address" : data.CommunityAddress,
            "country" : data.Country,
            "language": data.Language,
            "role_id":data.RoleId
            ] as [String : Any]
        
        print(parameters)
        // build your dictionary however appropriate
        
        let boundary = generateBoundaryString()
        
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_UpdateCommunity)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try createBodyWithParameters(parameters: parameters, filePathKey: "logo", imageData: data.profile_picture, imageName: "ProfilePicture.png", filePathKey1: "proof_id", imageData1: data.IDProof, imageName1: "IDProofPicture.png", boundary: boundary) as Data
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
                
            else {
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
                do {
                    
                    var jsonResult  = NSDictionary()
                    jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                    print("jsonResult: \(jsonResult)")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGatesUpdateCommunity"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                    
                } catch let error as NSError {
                    print(error)
                    //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignUpTutor"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                    // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignUpTutor"), object: nil)
                }
            }
        }
        task.resume()
    }
    
    // MARK: Update Profile
    func HostGatesAddCommunity(data: AddCommunityModle){
        let parameters = [
            "user_id" : data.userID,
            "title": data.CommunityTitle,
            "unique_name" : data.CommunityUniqueName,
            "type" : data.CommunityType,
            "address" : data.CommunityAddress,
            "country" : data.Country,
            "language": data.Language,
            "role_id" :data.RoleId,
            "admin_user_id":data.AdminUserID
            ] as [String : Any]
        
        print(parameters)
        // build your dictionary however appropriate
        
        let boundary = generateBoundaryString()
        
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_AddCommunity)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try createBodyWithParameters(parameters: parameters, filePathKey: "logo", imageData: data.profile_picture, imageName: "ProfilePicture.png", filePathKey1: "proof_id", imageData1: data.IDProof, imageName1: "IDProofPicture.png", boundary: boundary) as Data
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
                
            else {
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
                do {
                    
                    var jsonResult  = NSDictionary()
                    jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                    print("jsonResult: \(jsonResult)")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGatesAddCommunity"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                    
                } catch let error as NSError {
                    print(error)
                    //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignUpTutor"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                    // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignUpTutor"), object: nil)
                }
            }
        }
        task.resume()
    }
    
    
    // MARK: Update Profile
    func HostGatesBusienssDetailProfile(data: BusinessDataModel){
        let parameters = [
            "user_id" : data.userID,
            "name": data.BusinessName,
            "registration_number" : data.BusinessRegNumber,
            "address" : data.Address,
            "city" : data.City,
            "state" : data.State,
            "country" : data.Country,
            "date_format": data.DateFormat,
            "language": data.Langauge,
            "role_id" : data.RoleId,
            "admin_user_id":data.AdminUserID
            ] as [String : Any]
        
        print(parameters)
        // build your dictionary however appropriate
        
        let boundary = generateBoundaryString()
        
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_UpdateBusinessDetail)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        //let path1 = Bundle.main.path(forResource: "image1", ofType: "png")!
        //request.httpBody = try createBodyWithParameters(parameters: parameters, filePathKey: "profile_picture", imageData: data.ProfilePicture, imageName: "ProfilePicture.png", boundary: boundary) as Data
        
        request.httpBody = try createBodyWithParameters(parameters: parameters, filePathKey: "logo", imageData: data.profile_picture, imageName: "ProfilePicture.png", filePathKey1: "proof_id", imageData1: data.IDProof, imageName1: "IDProofPicture.png", boundary: boundary) as Data
        
        
        
        //        request.httpBody = try createBodyWithParameters_ID(parameters: parameters, filePathKey: "proof_id", imageData: data.IDProof, imageName: "IDProof.png", boundary: boundary) as Data
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
                
            else {
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
                do {
                    
                    var jsonResult  = NSDictionary()
                    jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                    print("jsonResult: \(jsonResult)")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGatesUpdateBusinessDetail"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                    
                } catch let error as NSError {
                    print(error)
                    //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignUpTutor"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                    // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignUpTutor"), object: nil)
                }
            }
        }
        task.resume()
    }
    
    
    func HostGateAddStaff(UniqueName:String!,UserId:Int!,Username:String!,Email:String!,Password:String!,CountryCode:String!,CountryName:String,PhoneNo:String! ,Role_Id:String!,Language:String!,Passport_Number:String!,DeviceType:String!,Device_ID:String!,RoleId:Int!,AdminuserId:Int!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_AddStaff)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "unique_name=%@&user_id=%d&username=%@&email=%@&password=%@&country_code=%@&phone=%@&country_id_number=%@&,id_number=%@&role=%@&language=%@&device_type=%@&device_id=%@&role_id=%d&admin_user_id=%d",UniqueName,UserId,Username,Email,Password,CountryCode,PhoneNo,CountryCode,Passport_Number,Role_Id,Language,DeviceType,Device_ID,RoleId,AdminuserId)
            
             // let postString = String(format: "language=%@&username=%@&password=%@&role_id=%d&device_type=%@&device_id=%@",Language,Username,Password,Role_Id,DeviceType,Device_ID)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateAddStaffNotification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    func HostGateGetAllStaff(Language:String!,UserId:Int!,RoleId:Int!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_GetAllStaff)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&user_id=%d&role_id=%d",Language,UserId,RoleId)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateGetAllStaffNotification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    // MARK: Host Gate Property List
    func HostGatePropertylist(Language:String!,UserId:Int!,CommunityId:Int!,SearchKeyword:String!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_PropertyList)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&user_id=%d&community_id=%d&search_keyword=%@",Language,UserId,CommunityId,SearchKeyword)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGatePropertylistNotification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    // MARK: Host Gate Visitor list
    func HostGateGteVisitorList(Language:String!,UserID:Int!,CommunityID:Int!,Search_Keyword:String!,Search_Visitor_date:String!,Visitor_Sorting:String){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_GateVisitorList)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&user_id=%d&community_id=%d&search_keyword=%@&search_visitor_date=%@&visitor_sorting=%@",Language,UserID,CommunityID,Search_Keyword,Search_Visitor_date,Visitor_Sorting)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateGteVisitorListNotification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    
    // MARK: Host Gate Add Reverse Visitor
    func HostGateAddReverseVisitor(Language:String!,Count:String!,PropertyId:Int!,VisitorTypeID:Int!,UserId:Int!,Name:String!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_AddReverseVisitor)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&count=%@&property_id=%d&visitor_type_id=%d&user_id=%d&name=%@",Language,Count,PropertyId,VisitorTypeID,UserId,Name)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateAddReverseVisitorNotification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    // MARK: Host Gate Reverse Visitor List
    func HostGateReverseVisitorList(Language:String!,PropertyId:Int!,UserId:Int!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_ReverseVisitorList)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&property_id=%d&user_id=%d",Language,PropertyId,UserId)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateReverseVisitorListNotification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    // MARK: Visitor Check Out
    func HostGateVisitorCheckOut(Language:String!,VisitorId:Int!,PinCode:String!,Out_Datetime:String!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_CheckOut)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&visitor_id=%d&pin_code=%@&out_datetime=%@",Language,VisitorId,PinCode,Out_Datetime)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateVisitorCheckOutNotification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    
    // MARK: Visitor Detail
    func HostGateVisitorDetail(Language:String!,VisitorId:Int!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_GateVisitorDetail)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&visitor_id=%d",Language,VisitorId)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateVisitorDetailNotification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    // MARK: Free Accounts
    func HostGateFreeAccounts(Language:String!,UserID:Int!,RoleID:Int!,AdminuserId:Int!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_FreeAccount)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&user_id=%d&role_id=%d&admin_user_id=%d",Language,UserID,RoleID,AdminuserId)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateFreeAccountsNotification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
//    // MARK: Check Account Status
//    func HostGateCheckAccountStatus(Language:String!,UserID:Int!,RoleID:Int!,DeviceID:String!){
//        let API_Path = "\(Config().API_URL)"
//        let API_Method = "\(Config().API_CheckAccountStatus)"
//
//        let Parameter = String(format: "%@%@", API_Path,API_Method)
//
//        var request = URLRequest(url: URL(string: Parameter)!)
//        request.httpMethod = "POST"
//
//        let postString = String(format: "language=%@&user_id=%d&role_id=%d&device_id=%@",Language,UserID,RoleID,DeviceID)
//
//        request.httpBody = postString.data(using: .utf8)
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//
//                // check for fundamental networking error
//                print("error=\(String(describing: error))")
//                return
//            }
//            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
//                print("statusCode should be 200, but is \(httpStatus.statusCode)")
//                print("response = \(String(describing: response))")
//                return
//            }
//
//            let responseString = String(data: data, encoding: .utf8)
//            print("responseString = \(String(describing: responseString))")
//
//            if let httpResponse = response as? HTTPURLResponse {
//                if httpResponse.statusCode != 200 {
//                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
//                }else {
//
//                    DispatchQueue.main.async() {
//                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
//                            var jsonResult: NSDictionary?
//                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
//                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
//                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
//                        }else {
//                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
//                        }
//                    }
//                }
//            }
//
//
//        }
//        task.resume()
//    }
    
    
    
    
    ///Get Device Listl----
       func GetDeviceList(){
           
           let API_Path = "\(Config().API_URL)"
           let API_Method = "\(Config().API_GetDeviceList)"
           
           let Parameter = String(format: "%@%@", API_Path,API_Method)
           
           var request = URLRequest(url: URL(string: Parameter)!)
           request.httpMethod = "GET"
           
           let postString = String(format: "")
           
           request.httpBody = postString.data(using: .utf8)
           let task = URLSession.shared.dataTask(with: request) { data, response, error in
               guard let data = data, error == nil else {
                   
                   // check for fundamental networking error
                   print("error=\(String(describing: error))")
                   return
               }
               if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                   print("statusCode should be 200, but is \(httpStatus.statusCode)")
                   print("response = \(String(describing: response))")
               }
               // else {
               let responseString = String(data: data, encoding: .utf8)
               print("responseString = \(String(describing: responseString))")
               
               var jsonResult  = NSDictionary()
               jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
               print("jsonResult: \(jsonResult)")
               
               NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GetDeviceList"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
               //  }
           }
           task.resume()
       }
    
    
    // MARK: Check Account Status
    func HostGateCheckAccountStatus(Language:String!,UserID:Int!,RoleID:Int!,DeviceID:String!,Role:Int!,AdminUserID:Int!,device_id:NSString!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_CheckAccountStatus)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&user_id=%d&role_id=%d&device_id=%@&role=%d&admin_user_id=%d&device_id=%@",Language,UserID,RoleID,DeviceID,Role,AdminUserID,device_id)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    
    // MARK: Reporting
    func HostGateReporting(Language:String!,UserID:Int!,RoleID:Int!,AdminUserID:Int!){
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_Reporting)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        
        let postString = String(format: "language=%@&user_id=%d&role_id=%d&admin_user_id=%d",Language,UserID,RoleID,AdminUserID)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                }else {
                    
                    DispatchQueue.main.async() {
                        if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                            var jsonResult: NSDictionary?
                            jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                            print("jsonResult: \(String(describing: jsonResult ?? nil))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateReportingNotification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                        }else {
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                        }
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    
    
    // MARK: Get All Visitor List
    func HostGateGetAllVisList(CommunityId:Int!,StartDate:String!,EndDate:String!,language:String!){
           let API_Path = "\(Config().API_URL)"
           let API_Method = "\(Config().API_GetAllVisList)"
           
           let Parameter = String(format: "%@%@", API_Path,API_Method)
           
           var request = URLRequest(url: URL(string: Parameter)!)
           request.httpMethod = "POST"
           
           let postString = String(format: "community_id=%d&start_date=%@&end_date=%@&language=%@",CommunityId,StartDate,EndDate,language)
           
           request.httpBody = postString.data(using: .utf8)
           let task = URLSession.shared.dataTask(with: request) { data, response, error in
               guard let data = data, error == nil else {
                   
                   // check for fundamental networking error
                   print("error=\(String(describing: error))")
                   return
               }
               if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                   print("statusCode should be 200, but is \(httpStatus.statusCode)")
                   print("response = \(String(describing: response))")
                   return
               }
               
               let responseString = String(data: data, encoding: .utf8)
               print("responseString = \(String(describing: responseString))")
               
               if let httpResponse = response as? HTTPURLResponse {
                   if httpResponse.statusCode != 200 {
                       SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                   }else {
                       
                       DispatchQueue.main.async() {
                           if((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                               var jsonResult: NSDictionary?
                               jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                               print("jsonResult: \(String(describing: jsonResult ?? nil))")
                               NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGateGetAllVisListNotification"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                           }else {
                               SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Server not responding" , buttonTitle: "OK")
                           }
                       }
                   }
               }
               
               
           }
           task.resume()
       }
       
       
    
    
    
    
    // MARK: Update Profile
    func HostGatesUpdateProfile(data: UpdateModel){
        let parameters = [
            "user_id" : data.userID,
            "full_name": data.FullName,
            "country_code" : data.CountryCode,
            "phone" : data.PhoneNumber,
            "email" : data.Email,
            "country_id_number" : data.CountryIDNuumber,
            "id_number" : data.IDNumber,
            "language": data.Language,
            "role_id" : data.RoleId
            ] as [String : Any]
        
        print(parameters)
        // build your dictionary however appropriate
        
        let boundary = generateBoundaryString()
        
        let API_Path = "\(Config().API_URL)"
        let API_Method = "\(Config().API_UpdateUserProfile)"
        
        let Parameter = String(format: "%@%@", API_Path,API_Method)
        
        var request = URLRequest(url: URL(string: Parameter)!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        //let path1 = Bundle.main.path(forResource: "image1", ofType: "png")!
        //request.httpBody = try createBodyWithParameters(parameters: parameters, filePathKey: "profile_picture", imageData: data.ProfilePicture, imageName: "ProfilePicture.png", boundary: boundary) as Data
        
        request.httpBody = try createBodyWithParameters(parameters: parameters, filePathKey: "profile_picture", imageData: data.profile_picture, imageName: "ProfilePicture.png", filePathKey1: "proof_id", imageData1: data.IDProof, imageName1: "IDProofPicture.png", boundary: boundary) as Data
        
        
        
        //        request.httpBody = try createBodyWithParameters_ID(parameters: parameters, filePathKey: "proof_id", imageData: data.IDProof, imageName: "IDProof.png", boundary: boundary) as Data
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
                
            else {
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
                do {
                    
                    var jsonResult  = NSDictionary()
                    jsonResult  = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                    print("jsonResult: \(jsonResult)")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HostGatesUpdateProfile"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                    
                } catch let error as NSError {
                    print(error)
                    //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignUpTutor"), object: self, userInfo: jsonResult as? [AnyHashable : Any])
                    // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignUpTutor"), object: nil)
                }
            }
        }
        task.resume()
    }
    
    func mimeType(for path: String) -> String {
        let url = NSURL(fileURLWithPath: path)
        
        let pathExtension = url.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream";
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func createBodyWithParameters(parameters: [String: Any]?, filePathKey: String?, imageData: NSData!,imageName : String?, filePathKey1: String?, imageData1: NSData!,imageName1 : String?, boundary: String) -> NSData {
        
        let body = NSMutableData()
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        if (imageData != nil) {
            
            
            let mimetype = mimeType(for: imageName!)
            
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(imageName! as String)\"\r\n")
            body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
            body.append(imageData as Data)
            body.appendString(string: "\r\n")
            
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey1!)\"; filename=\"\(imageName1! as String)\"\r\n")
            body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
            body.append(imageData1 as Data)
            body.appendString(string: "\r\n")
            
        }
        
        body.appendString(string: "--\(boundary)--\r\n")
        return body
    }
    
    
}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}


    

