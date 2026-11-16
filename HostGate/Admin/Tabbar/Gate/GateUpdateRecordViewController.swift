//
//  GateUpdateRecordViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 23/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import AssetsLibrary
import Photos
import DKImagePickerController
import AdSupport
import GiFHUD_Swift

class GateUpdateRecordViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate {
    
    
    //MARK:- IBOutlet
    @IBOutlet weak var title_lbl: UILabel!
    @IBOutlet weak var dateTxt: UITextField!
    @IBOutlet weak var timeTxt: UITextField!
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var pinNumberTxt: UITextField!
    @IBOutlet weak var update_btn: UIButton!
    
    var str_date:NSString!
    var str_time:NSString!
    var str_ppinumber:NSString!
    
    var defaults:UserDefaults!
    var visitorId:Int!
    var Pincode:String!
    var datetime = String()
    var datepicker:UIDatePicker! = UIDatePicker()
    var datepicker1:UIDatePicker! = UIDatePicker()
    var imageArray = NSMutableArray()
    var CollectionImageArray = NSMutableArray()
    var dict_responce = NSMutableDictionary()
    var assets: [DKAsset]?
    let types: [DKImagePickerControllerAssetType] = [.allAssets, .allPhotos, .allAssets]
    var pickerController: DKImagePickerController!
    var user_Id:Int!
    var roleId:Int!
    var adminuserid:Int!
    var role:Int!
    var deviceTocken = NSString()
    let identifierManager = ASIdentifierManager.shared()
    var deviceId = String()
    @IBOutlet weak var collectionHeightCons: NSLayoutConstraint!
    
    //MARK:- Create Variable for language localizations
    var language:String!
    var dGlocale = DGLocalization()
    
    //MARK:- Login WebService
     @objc func HostGateAccountStatusAction(_ notification: Notification) {
         let status = (notification.userInfo?["status"] as? Int)!
         let str_message = (notification.userInfo?["message"] as? String)!
         
         DispatchQueue.main.async() {
             
             if status == 0{
                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
//                 self.removeAllOverlays()
                 self.defaults.set("0", forKey: "Check_User_For_Support_Condition")
                
             }
             else if status == 1{
                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                 SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                 self.defaults.set("1", forKey: "Check_User_For_Support_Condition")
//                 self.removeAllOverlays()
                
             }else {
                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                 SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                 let deafults = UserDefaults.standard
                 deafults.set(nil, forKey: "Logoutstatus")
                 deafults.synchronize()
                 let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "AdminLoginViewController") as! AdminLoginViewController
                 self.navigationController?.pushViewController(Leaderboard, animated: true)
             }
         }
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIFHUD.shared.setGif(named: "loader.gif")
        defaults = UserDefaults.standard
         language = defaults.value(forKey: "Language") as? String
        visitorId = defaults.integer(forKey: "VISTORID")
        Pincode = defaults.value(forKey: "PINCODE") as? String
        role = defaults.integer(forKey: "ROLE")
        deviceTocken = defaults.value(forKey: "Devicetoken") as! NSString
        user_Id = defaults.integer(forKey: "UserIDGet")
        roleId = defaults.integer(forKey: "RoleId")
        adminuserid = defaults.integer(forKey: "AdminUserId")
        if identifierManager.isAdvertisingTrackingEnabled {
            deviceId = identifierManager.advertisingIdentifier.uuidString
        }
        
        collectionHeightCons.constant = 0
        
        dateTxt.delegate = self
        timeTxt.delegate = self
        
        datepicker.datePickerMode = UIDatePicker.Mode.date
        dateTxt.inputView = datepicker
        datepicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: UIControl.Event.valueChanged)
        
        datepicker1.datePickerMode = UIDatePicker.Mode.time
        timeTxt.inputView = datepicker1
        datepicker1.addTarget(self, action: #selector(handleDatePicker1(sender:)), for: UIControl.Event.valueChanged)
        
        
        //MARK:- language Code Start
        
        if language == "en" {
            self.update_btn.setTitle("SUBMIT", for: .normal)
        }else if language == "ar" {
            self.update_btn.setTitle("إرسال", for: .normal)
        }
        
        
        if language == nil {
            
        }else {
            DGLocalization.sharedInstance.Delegate = self;
            decorate()
        }
        
        
        Parsing().HostGateCheckAccountStatus(Language: language, UserID: user_Id, RoleID: roleId, DeviceID: deviceId, Role: role, AdminUserID: adminuserid, device_id: deviceTocken)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateAccountStatusAction), name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
    }
    
    
    //MARK:- language Function
    func decorate() {
        self.title_lbl.text = language == "en" ? "Check-In" : "وقت الدخول"
        self.dateTxt.placeholder = language == "en" ? "Enter date" : "أدخل التاريخ"
        self.timeTxt.placeholder = language == "en" ? "Enter time" : "أدخل الوقت"
        self.pinNumberTxt.placeholder = language == "en" ? "Enter pin code" : "أدخل رقم التعريف الشخصي"
        if language .isEqual("en") || language .isEqual(""){
            self.dateTxt.textAlignment = .left
            self.timeTxt.textAlignment = .left
            self.pinNumberTxt.textAlignment = .left
        }else if language .isEqual("ar") {
            self.dateTxt.textAlignment = .right
            self.timeTxt.textAlignment = .right
            self.pinNumberTxt.textAlignment = .right
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if  textField == dateTxt {
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "yyyy-MM-dd"
            let dateString1 = dateFormatter1.string(from: datepicker.date)
            dateTxt.text = dateString1
        }else if textField == timeTxt {
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "hh:mm a"
            let dateString1 = dateFormatter1.string(from: datepicker1.date)
            timeTxt.text = dateString1
        }
    }
    
    
    //MARK:- Date Button Action
    @objc func handleDatePicker(sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: datepicker.date)
        dateTxt.text = dateString
        
    }
    
    //MARK:- Date Button Action
    @objc func handleDatePicker1(sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        let dateString = dateFormatter.string(from: datepicker1.date)
        timeTxt.text = dateString
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.CollectionImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MultipleImageCell
        let image_show = UIImage(data: self.CollectionImageArray[indexPath.row] as! Data)
        
        cell.image.image = image_show
        cell.cancleBtn.tag = indexPath.item
        cell.cancleBtn.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func handleTap(_ sender:UIButton){
        var btn = sender as? UIButton
        CollectionImageArray.removeObject(at: btn!.tag)
        if CollectionImageArray.count == 0 {
            self.collectionHeightCons.constant = 0
        }else{
            self.collectionHeightCons.constant = 150
        }
        imageCollection.reloadData()
    }
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func updateBtnAction(_ sender: Any) {
        str_date = dateTxt.text as NSString?
        str_time = timeTxt.text as NSString?
        str_ppinumber = pinNumberTxt.text as NSString?
        
        datetime = (str_date as String) + (str_time as String)
        
        if str_date .isEqual(to: ""){
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter date." : "يرجى إدخال التاريخ" , buttonTitle: language == "en" ? "OK" : "حسنا")
        }else if str_time .isEqual(to: "") {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter time." : "يرجى إدخال الوقت" , buttonTitle: language == "en" ? "OK" : "حسنا")
        }else if str_ppinumber .isEqual(to: "") {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter pin code." : "يرجى إدخال الرمز السري.", buttonTitle: language == "en" ? "OK" : "حسنا")
        }
        else if CollectionImageArray.count == 0 {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please choose at least one image." : "الرجاء إدخال رقم التعريف الشخصي" , buttonTitle: language == "en" ? "OK" : "حسنا")
        }
        else {
            if Reachability.isConnectedToNetwork() == true {
                let data = CheckInModel()
                data.VisitorID = visitorId
                data.Pincode = str_ppinumber as String
                data.Langauge = "en"
                data.InDateTime = datetime
                // self.showWaitOverlay()
                self.sendMedia1(data: data)
            }else {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Internet connection not available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }
        }
    }
    
    func sendMedia1(data: CheckInModel){
        
        //Loader Start
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:3)
        
        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setObject(GateUpdateRecordViewController.getVal(data.VisitorID), forKey: "visitor_id" as NSCopying)
        parameterDictionary.setObject(GateUpdateRecordViewController.getVal(data.Pincode), forKey: "pin_code" as NSCopying)
        parameterDictionary.setObject(GateUpdateRecordViewController.getVal(data.InDateTime), forKey: "in_datetime" as NSCopying)
        parameterDictionary.setObject(GateUpdateRecordViewController.getVal(data.Langauge), forKey: "language" as NSCopying)
        
        let dataArr = NSMutableArray()
        if CollectionImageArray != nil{
            for index in 0..<self.CollectionImageArray.count {
                var image_final = UIImage()
                image_final = UIImage(data: CollectionImageArray.object(at: index) as! Data)!
                // img_finalArray.add(image_final)
                let dataDict = NSMutableDictionary()
                dataDict.setObject("upload_img", forKey: "upload_img" as NSCopying)
                dataDict.setObject(resize(image_final).pngData()!, forKey: "imageData" as NSCopying)
                dataDict.setObject("png", forKey: "ext" as NSCopying)
                dataArr.add(dataDict)
                
            }
        }
        
        
        let MethodName = "checkInVisitor"
        
        GateUpdateRecordViewController.getAPIResponseFile(parameterDictionary: parameterDictionary, methodName: MethodName as NSString ,dataArray: dataArr){(responseData,error)-> Void in
            
            let status = GateUpdateRecordViewController.getVal(responseData?.object(forKey: "status")) as? String ?? "0"
            let message = GateUpdateRecordViewController.getVal(responseData?.object(forKey: "message")) as? String ?? "0"
            //            if let data =  GateUpdateRecordViewController.getVal(responseData?.object(forKey: "response")) as? NSMutableDictionary {
            //                self.dict_responce = data
            //            }else{
            //                return
            //            }
            
            if status == "1" {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:message , buttonTitle: "OK")
                self.dateTxt.text = ""
                self.timeTxt.text = ""
                self.collectionHeightCons.constant = 0
                NotificationCenter.default.post(name: NSNotification.Name("CheckIn"), object: nil)
                self.navigationController?.popViewController(animated: true)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                
            }else{
                
                self.showAlertUpate(message: message)
                
                
            }
            //Loader Stop
//            self.removeAllOverlays()
            GIFHUD.shared.dismiss()
            
        }
        
    }
    
    func showAlertUpate(message: String) {
           let alertController = UIAlertController(title: "HostGates", message: message, preferredStyle: .alert)
           
           // Create the actions
           let okAction = UIAlertAction(title: self.language == "en" ? "OK" : "حسنا", style: UIAlertAction.Style.default) {
               UIAlertAction in
               GIFHUD.shared.dismiss()
           }
           
           alertController.addAction(okAction)
           self.present(alertController, animated: true, completion: nil)
       }
    
    
    
    class func getVal(_ param:Any!) -> AnyObject {
        
        
        
        
        if param == nil
        {
            return "" as AnyObject
        }
        else if param is NSNull
        {
            return "" as AnyObject
        }
        else if param is NSNumber
        {
            let aString:String = "\(param!)"
            return aString as AnyObject
        }
        else if param is Double
        {
            return "\(param)" as AnyObject
        }
        else
        {
            return param as AnyObject
        }
        
    }
    
    func resize(_ image: UIImage) -> UIImage {
        var actualHeight = Float(image.size.height)
        var actualWidth = Float(image.size.width)
        let maxHeight: Float = 900.0
        let maxWidth: Float = 900.0
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        let compressionQuality: Float = 0.5
        //50 percent compression
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = img?.jpegData(compressionQuality: 0.5)
        UIGraphicsEndImageContext()
        return UIImage(data: imageData!) ?? UIImage()
    }
    class func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    class func getAPIResponseFile( parameterDictionary :NSDictionary,methodName:NSString, dataArray:NSArray, success: @escaping (( _ iTunesData: NSDictionary?,_ error:NSError?) -> Void)) {
        
        let apiPath = "\(Config().API_URL)\(methodName)"
        
        let request = NSMutableURLRequest(url:NSURL(string: apiPath)! as URL);
        request.httpMethod = "POST"
        
        let boundary = self.generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var param : [String:String] = [:]
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 30.0
        sessionConfig.timeoutIntervalForResource = 30.0
        
        for (key,val) in parameterDictionary {
            param[key as! String] = val as? String
        }
        
        request.httpBody = createBodyWithParameters(parameters: param, imageArray: dataArray, boundary: boundary) as Data
        
        loadDataFromURL(request: request, completion:{(data, error) -> Void in
            //2
            if let urlData = data {
                
                success(urlData,error)
            }
            else
            {
                // SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:error?.domain ?? "Server not responding" , buttonTitle: "OK")
            }
        })
        
    }
    
    class func createBodyWithParameters(parameters: [String: String]?, imageArray: NSArray, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.append(("--\(boundary)\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
                body.append(("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
                body.append(("\(value)\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
            }
        }
        
        
        var imageData = Data()
        var imageName  = ""
        // print(imageArray)
        for index in 0..<imageArray.count {
            
            let dataDictionary = imageArray[index] as! NSDictionary
            
            imageName = dataDictionary.object(forKey: "upload_img") as! String
            imageData = dataDictionary.object(forKey: "imageData") as! Data
            
            let mimetype = "application/octet-stream"
            
            let imageName = dataDictionary.object(forKey: "upload_img") as! NSString
            let imageExt = dataDictionary.object(forKey: "ext") as! NSString
            let imageData = dataDictionary.object(forKey: "imageData") as! Data
            //  let imageType = dataDictionary.object(forKey: "imagetype") as! NSString
            
            let randmstr = self.randomStringWithLength(8)
            
            body.append(("--\(boundary)\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
            body.append(("Content-Disposition: form-data; name=\"\(imageName)[\(index)]\"; filename=\"\(randmstr).\(imageExt)\"\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
            body.append(("Content-Type: \(mimetype)\r\n\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
            body.append(imageData as Data)
            body.append(("\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
            body.append(("--\(boundary)--\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
            
        }
        
        
        return body
    }
    class func randomStringWithLength (_ len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for _ in 0..<len {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        return randomString
    }
    
    class func loadDataFromURL( request: NSMutableURLRequest, completion:@escaping ( _ data: NSDictionary?, _ error: NSError?) -> Void) {
        // Use NSURLSession to get data from an NSURL
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main)
        {(response, data, error) in
            //print(error)
            if let responseError = error {
                Config().printData(responseError as NSObject)
                var jsonResult  = NSDictionary()
                jsonResult = ["status":"error","message":responseError.localizedDescription]
                jsonResult = ["status":"error","message":"Make sure your device is connected to the internet."]
                completion(jsonResult, responseError as NSError?)
            } else if let httpResponse = response as? HTTPURLResponse {
                Config().printData(httpResponse.statusCode as NSObject)
                if httpResponse.statusCode != 200 {
                    let base64String = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    Config().printData(base64String!)
                    var jsonResult  = NSDictionary()
                    jsonResult = ["status":"error","message":base64String!]
                    jsonResult = ["status":"error","message":"There is a problem with server, kindly try again."]
                    completion(jsonResult, nil)
                } else {
                    let base64String = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    Config().printData(base64String!)
                    
                    var jsonResult  = NSDictionary()
                    
                    let decodedString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    if((try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                        jsonResult  = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                    } else {
                        Config().printData(decodedString!)
                        jsonResult = ["status":"error","message":decodedString!]
                        jsonResult = ["status":"error","message":"There is a problem with server, kindly try again."]
                    }
                    
                    
                    Config().printData(jsonResult)
                    completion(jsonResult, nil)
                }
            }
        }
        //loadDataTask.resume()
    }
    
    func fetchImageData(){
        var dict = [String: Any]()
        if self.assets != nil{
            
            self.CollectionImageArray.removeAllObjects()
            self.imageArray.removeAllObjects()
            var isEnter: Bool = false
            for index in 0..<(self.assets?.count)!{
                
                let asset = self.assets![index]
                asset.fetchImage(with: CGSize(width: 800, height: 800), completeBlock: { image, info in
                    // asset.fetchImageWithSize(CGSize(width: 800, height: 800), completeBlock: { image, info in
                    
                    
                    if isEnter == true{
                        dict["type"] = "image"
                        dict["content"] = image
                        
                        let imageData_two = image!.jpegData(compressionQuality: 0.5)
                        
                        self.CollectionImageArray.add(imageData_two!)
                        //  append(imageData_two)
                        
                        print(self.imageArray)
                        
                        if self.imageArray.contains(image!){
                            self.imageArray.replaceObject(at: index, with: (image!))
                        }else{
                            self.imageArray.add(image!)
                        }
                        print(self.imageArray)
                        //    "<UIImage: 0x1c02acb40> size {68, 120} orientation 0 scale 1.000000"
                        
                        print("imageArray: \(self.imageArray.count)")
                        print("CollectionImageArray: \(self.CollectionImageArray.count)")
                        print("index = \(index)")
                        self.collectionHeightCons.constant = 150
                        self.imageCollection.reloadData()
                    }
                    
                })
                
                
            }
            isEnter = true
            print(self.CollectionImageArray)
            print(self.imageArray)
        }
    }
    
    @IBAction func uploadImageBtb(_ sender: Any) {
        let types: [DKImagePickerControllerAssetType] = [.allAssets, .allPhotos, .allAssets]
        let assetType = types[1]
        
        let sourceType: DKImagePickerControllerSourceType =  .both
        self.showImagePickerWithAssetType(
            assetType,
            sourceType: sourceType,singleSelect:false)
        
    }
    
    
    
    func showImagePickerWithAssetType(_ assetType: DKImagePickerControllerAssetType,sourceType: DKImagePickerControllerSourceType = .both,singleSelect: Bool) {
        
        let pickerController = DKImagePickerController()
        pickerController.assetType = assetType
        pickerController.sourceType = sourceType
        pickerController.singleSelect = singleSelect
        pickerController.allowMultipleTypes = true
        pickerController.maxSelectableCount = 4
        pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            print("didSelectAssets")
            print(assets.count)
            
            print(assets.count)
            if assets.count > 0{
                self.assets = assets
                self.fetchImageData()
                
            }
        }
        if UI_USER_INTERFACE_IDIOM() == .pad {
            pickerController.modalPresentationStyle = .formSheet
        }
        self.present(pickerController, animated: true) {}
    }
    
    
}

//MARK:-DGLoclalization Delegate
extension GateUpdateRecordViewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}
