//
//  ValidationClass.swift
//  Samksa
//
//  Created by Mac Mini on 17/12/14.
//  Copyright (c) 2014 Fullestop. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l <= r
    default:
        return !(rhs < lhs)
    }
}

class ValidationClass: NSObject {
    
    var language = UserDefaults.standard.value(forKey: "Language") as? String
    
    func validateUrl (_ stringURL : NSString) -> Bool {
        
        let urlRegEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[urlRegEx])
        //let urlTest = NSPredicate.predicateWithSubstitutionVariables(predicate)
        
        return predicate.evaluate(with: stringURL)
    }
    
    func isBlank (_ textfield:UITextField) -> Bool {
        
        let thetext = textfield.text
        let trimmedString = thetext!.trimmingCharacters(in: CharacterSet.whitespaces)
        
        if trimmedString.isEmpty {
            return true
        }
        return false
    }
    
    func isTextViewBlank(_ textview:UITextView) -> Bool {
        
        if textview.text.isEmpty {
            return true
        }
        return false
    }
    
    func isValidEmail(_ EmailStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let range = EmailStr.range(of: emailRegEx, options:.regularExpression)
        let result = range != nil ? true : false
        return !result
    }
    
    func isValidPWD(_ PwdStr:String) -> Bool {
        
        let PwdRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{10,}"
        let range = PwdStr.range(of: PwdRegEx, options:.regularExpression)
        let result = range != nil ? true : false
        return !result
    }
    func ValidateAddgateAccountForm(_ loginVCValidateObj:AddGateAccountsViewController) -> Bool {
        if isBlank(loginVCValidateObj.GatenumbertxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter gate number." : "الرجاء إدخال رقم البوابة.", buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if loginVCValidateObj.GatenumbertxtField.text!.count < 1 {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Gate number should be minimum 1 characters." : "يجب أن يكون رقم البوابة 1 حرف على الأقل." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }
        else if isBlank(loginVCValidateObj.GateNameTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter gate name." : "الرجاء إدخال اسم البوابة." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if loginVCValidateObj.GateNameTxtField.text!.count < 3 {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Gate name should be minimum 3 characters." : "يجب أن يكون اسم البوابة 3 أحرف على الأقل." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }
        else if isBlank(loginVCValidateObj.UserNameTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter username." : "الرجاء إدخال اسم المستخدم.", buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if loginVCValidateObj.UserNameTxtField.text!.count < 3  {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Username should be minimum 3 characters." : "يجب أن يكون اسم المستخدم 3 أحرف على الأقل." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }
        else if isBlank(loginVCValidateObj.PasswordTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter password." : "الرجاء إدخال كلمة المرور", buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if loginVCValidateObj.PasswordTxtField.text!.count < 6 || loginVCValidateObj.PasswordTxtField.text!.count > 16 {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Password must be 6 to 16 Characters." : "يجب أن تكون كلمة المرور من 6 إلى 16 حرفًا." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }
        else{
            return true
        }
    }
    
    func ValidateAddgateAccountForm1(_ loginVCValidateObj:AddGateAccountsViewController) -> Bool {
        if isBlank(loginVCValidateObj.GatenumbertxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter gate number." : "الرجاء إدخال رقم البوابة.", buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if loginVCValidateObj.GatenumbertxtField.text!.count < 1 {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Gate number should be minimum 1 characters." : "يجب أن يكون رقم البوابة 1 حرف على الأقل." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }
        else if isBlank(loginVCValidateObj.GateNameTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter gate name." : "يرجى emter اسم البوابة.", buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if loginVCValidateObj.GateNameTxtField.text!.count < 3 {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Gate name should be minimum 3 characters." : "يجب أن يكون اسم البوابة 3 أحرف على الأقل." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }
        else if isBlank(loginVCValidateObj.UserNameTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter username." : "الرجاء إدخال اسم المستخدم." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if loginVCValidateObj.UserNameTxtField.text!.count < 3  {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Username should be minimum 3 characters." : "يجب أن يكون اسم المستخدم 3 أحرف على الأقل.", buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }
        else{
            return true
        }
    }
    
    
    func ValidateResidentialComplexForm(_ loginVCValidateObj:AddEmployeeAccountViewController) -> Bool {
        if isBlank(loginVCValidateObj.BuildingNumberTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter building number." : "الرجاء إدخال رقم المبنى." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if loginVCValidateObj.BuildingNumberTxtField.text!.count < 1 {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Building number should be minimun 3 characters." : "يجب أن لا يقل عدد المباني عن 3 أحرف." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }
        else if isBlank(loginVCValidateObj.UnitNumberTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter unit/floor number." : "الرجاء إدخال رقم الوحدة / الطابق." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if loginVCValidateObj.UnitNumberTxtField.text!.count < 1  {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Unit/Floor number should be minimum 3 characters." : "يجب ألا يقل عدد الوحدات / الكلمة عن 3 أحرف." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if isBlank(loginVCValidateObj.AssignGateTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please select assign gate account." : "الرجاء تحديد تعيين حساب بوابة." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if (loginVCValidateObj.IDarray.count == 0) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please add at least one gate." : "الرجاء إضافة بوابة واحدة على الأقل." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }
        else if isBlank(loginVCValidateObj.UsernametxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter owner name." : "الرجاء إدخال اسم المالك." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if loginVCValidateObj.UsernametxtField.text!.count < 3   {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Owner name should be minimum 3 characters." : "يجب أن يكون اسم المالك 3 أحرف على الأقل." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if isBlank(loginVCValidateObj.NationalityTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please select nationality." : "الرجاء اختيار الجنسية" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }
        else if isBlank(loginVCValidateObj.IdNumberTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter National ID / Passport Number." : "الرجاء إدخال الرقم القومي / رقم جواز السفر." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if loginVCValidateObj.IdNumberTxtField.text!.count < 1 {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "National ID / Passport Number should be minimum 3 characters." : "يجب أن يكون رقم الهوية الوطنية / جواز السفر 3 أحرف على الأقل." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if isBlank(loginVCValidateObj.EmailtxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter email." : "الرجاء إدخال البريد الإلكتروني." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if isBlank(loginVCValidateObj.CountryCodeTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please select country code." : "يرجى اختيار رمز البلد." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }
        else if isBlank(loginVCValidateObj.MobileNumberTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter mobile number." : "الرجاء إدخال رقم الجوال" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if loginVCValidateObj.MobileNumberTxtField.text!.count < 7 || loginVCValidateObj.MobileNumberTxtField.text!.count > 15 {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Mobile number must be more than 7 and less than 15 numbers only." : "يجب أن يكون رقم الجوال أكثر من 7 وأقل من 15 رقمًا فقط." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }
        else if isBlank(loginVCValidateObj.UniqueNameTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter username." : "الرجاء إدخال اسم المستخدم." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if loginVCValidateObj.UniqueNameTxtField.text!.count < 3 {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Unique name should be minimum 3 characters." : "يجب أن يكون الاسم الفريد 3 أحرف على الأقل." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }
        else if isBlank(loginVCValidateObj.PasswordTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter password." : "الرجاء إدخال كلمة المرور" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if loginVCValidateObj.PasswordTxtField.text!.count < 6 || loginVCValidateObj.PasswordTxtField.text!.count > 16 {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Password must be 6 to 16 Characters." : "يجب أن تكون كلمة المرور من 6 إلى 16 حرفًا." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }
        else{
            return true
        }
    }
    func ValidateResidentialComplexForm1(_ loginVCValidateObj:AddEmployeeAccountViewController) -> Bool {
        if isBlank(loginVCValidateObj.BuildingNumberTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter building number." : "الرجاء إدخال رقم المبنى." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if loginVCValidateObj.BuildingNumberTxtField.text!.count < 1 {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Building number should be minimun 3 characters." : "يجب أن لا يقل عدد المباني عن 3 أحرف." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }
        else if isBlank(loginVCValidateObj.UnitNumberTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter unit/floor number." : "الرجاء إدخال رقم الوحدة / الطابق." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if loginVCValidateObj.UnitNumberTxtField.text!.count < 1  {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Unit/Floor number should be minimum 3 characters." : "يجب ألا يقل عدد الوحدات / الكلمة عن 3 أحرف." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if isBlank(loginVCValidateObj.AssignGateTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please select assign gate account." : "الرجاء تحديد تعيين حساب بوابة." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if (loginVCValidateObj.gate_ids.count == 0) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please add at least one gate." : "الرجاء إضافة بوابة واحدة على الأقل." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
        loginVCValidateObj.view.endEditing(true)
        return false
        }
        else if isBlank(loginVCValidateObj.UsernametxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter owner name." : "الرجاء إدخال اسم المالك." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if loginVCValidateObj.UsernametxtField.text!.count < 3 {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Owner name should be minimum 3 characters." : "يجب أن يكون اسم المالك 3 أحرف على الأقل." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if isBlank(loginVCValidateObj.NationalityTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please select nationality." : "الرجاء اختيار الجنسية" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }
        else if isBlank(loginVCValidateObj.IdNumberTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter National ID / Passport Number." : "الرجاء إدخال الرقم القومي / رقم جواز السفر." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }
        else if loginVCValidateObj.IdNumberTxtField.text!.count < 1 {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "National id number should be minimum 3 characters." : "يجب أن يكون رقم الهوية الوطنية 3 أحرف على الأقل." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if isBlank(loginVCValidateObj.EmailtxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter email." : "الرجاء إدخال البريد الإلكتروني." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }
//        else if isBlank(loginVCValidateObj.CountryCodeTxtField) {
//            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please select country code." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
//            loginVCValidateObj.view.endEditing(true)
//            return false
//        }
        else if isBlank(loginVCValidateObj.MobileNumberTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter mobile number." : "الرجاء إدخال رقم الجوال" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if loginVCValidateObj.MobileNumberTxtField.text!.count < 7 || loginVCValidateObj.MobileNumberTxtField.text!.count > 15 {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Mobile number must be more than 7 and less than 15 numbers only." : "يجب أن يكون رقم الجوال أكثر من 7 وأقل من 15 رقمًا فقط." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }
        else if isBlank(loginVCValidateObj.UniqueNameTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter unique name." : "الرجاء إدخال اسم فريد" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if loginVCValidateObj.UniqueNameTxtField.text!.count < 3 {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Unique name should be minimum 3 characters." : "يجب أن يكون الاسم الفريد 3 أحرف على الأقل." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }
        else{
            return true
        }
    }

    func ValidateCorporateofficeForm(_ loginVCValidateObj:AddCommunityUserAccountVC) -> Bool {
        if isBlank(loginVCValidateObj.BuildingNumberTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter building number." : "الرجاء إدخال رقم المبنى." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if loginVCValidateObj.BuildingNumberTxtField.text!.count < 1  {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Building number should be minimum 3 characters." : "يجب أن يكون رقم المبنى 3 أحرف على الأقل." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if isBlank(loginVCValidateObj.UnitNumberTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter unit/floor number." : "الرجاء إدخال رقم الوحدة / الطابق." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if isBlank(loginVCValidateObj.AssignGateTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please select assign gate account." : "الرجاء تحديد تعيين حساب بوابة." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if (loginVCValidateObj.IDarray.count == 0) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please add at least one gate." : "الرجاء إضافة بوابة واحدة على الأقل." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
       loginVCValidateObj.view.endEditing(true)
       return false
       }
        else if isBlank(loginVCValidateObj.UsernametxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter employee name." : "الرجاء إدخال اسم الموظف." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }
        else if loginVCValidateObj.UsernametxtField.text!.count < 3  {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Employee name should be minimum 3 characters." : "يجب أن يكون اسم الموظف 3 أحرف على الأقل." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if isBlank(loginVCValidateObj.EmployeNumberTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter employee number." : "الرجاء إدخال رقم الموظف." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }
        else if isBlank(loginVCValidateObj.OfficeNumberTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter office number." : "الرجاء إدخال رقم المكتب." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if isBlank(loginVCValidateObj.DepartmentTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter department." : "الرجاء إدخال القسم." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if isBlank(loginVCValidateObj.TitleTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter title." : "الرجاء إدخال العنوان." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if loginVCValidateObj.TitleTxtField.text!.count < 3 {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Title should be minimum 3 characters." : "يجب أن يكون العنوان 3 أحرف على الأقل." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }
        else if isBlank(loginVCValidateObj.EmailtxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter email." : "الرجاء إدخال البريد الإلكتروني." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if isBlank(loginVCValidateObj.CountryCodeTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please select country code." : "يرجى اختيار رمز البلد." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }
        else if isBlank(loginVCValidateObj.MobileNumberTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter mobile number." : "الرجاء إدخال رقم الجوال" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if loginVCValidateObj.MobileNumberTxtField.text!.count < 7 || loginVCValidateObj.MobileNumberTxtField.text!.count > 15 {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Mobile number must be more than 7 and less than 15 numbers only." : "يجب أن يكون رقم الجوال أكثر من 7 وأقل من 15 رقمًا فقط." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }
        else if isBlank(loginVCValidateObj.UniqueNameTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter username." : "الرجاء إدخال اسم المستخدم." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if loginVCValidateObj.UniqueNameTxtField.text!.count < 3  {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Unique name should be minimum 3 characters." : "يجب أن يكون الاسم الفريد 3 أحرف على الأقل." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }
        else if isBlank(loginVCValidateObj.PasswordTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter password." : "الرجاء إدخال كلمة المرور" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if loginVCValidateObj.PasswordTxtField.text!.count < 6 || loginVCValidateObj.PasswordTxtField.text!.count > 16 {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Password must be 6 to 16 Characters." : "يجب أن تكون كلمة المرور من 6 إلى 16 حرفًا.", buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }
        else{
            return true
        }
    }
    
    func ValidateCorporateofficeForm1(_ loginVCValidateObj:AddCommunityUserAccountVC) -> Bool {
        if isBlank(loginVCValidateObj.BuildingNumberTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter building number." : "الرجاء إدخال رقم المبنى." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if loginVCValidateObj.BuildingNumberTxtField.text!.count < 1  {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Building number should be minimum 3 characters." : "يجب أن يكون رقم المبنى 3 أحرف على الأقل." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if isBlank(loginVCValidateObj.UnitNumberTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter unit/floor number." : "الرجاء إدخال رقم الوحدة / الطابق." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if loginVCValidateObj.UnitNumberTxtField.text!.count < 1 {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Unit/Floor number should be minimum 3 characters." : "يجب ألا يقل عدد الوحدات / الكلمة عن 3 أحرف." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if isBlank(loginVCValidateObj.AssignGateTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please select assign gate account." : "الرجاء تحديد تعيين حساب بوابة." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if (loginVCValidateObj.IDarray.count == 0) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please add at least one gate." : "الرجاء إضافة بوابة واحدة على الأقل." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }
        else if isBlank(loginVCValidateObj.UsernametxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter employee name." : "الرجاء إدخال اسم الموظف." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }
        else if loginVCValidateObj.UsernametxtField.text!.count < 3 {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Employee name should be minimum 3 characters." : "يجب أن يكون اسم الموظف 3 أحرف على الأقل." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if isBlank(loginVCValidateObj.EmployeNumberTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter employee number." : "الرجاء إدخال رقم الموظف." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }
        else if isBlank(loginVCValidateObj.OfficeNumberTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter office number." : "الرجاء إدخال رقم المكتب." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if isBlank(loginVCValidateObj.DepartmentTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter department." : "الرجاء إدخال القسم." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if loginVCValidateObj.DepartmentTxtField.text!.count < 1 {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Department should be minimum 3 characters." : "يجب أن يكون القسم 3 أحرف على الأقل." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }
        else if isBlank(loginVCValidateObj.TitleTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter title." : "الرجاء إدخال العنوان." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if loginVCValidateObj.TitleTxtField.text!.count < 1 {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Title should be minimum 3 characters." : "يجب أن يكون العنوان 3 أحرف على الأقل." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }
        else if isBlank(loginVCValidateObj.EmailtxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter email." : "الرجاء إدخال البريد الإلكتروني." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }
//        else if isBlank(loginVCValidateObj.CountryCodeTxtField) {
//            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please select country code." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
//            loginVCValidateObj.view.endEditing(true)
//            return false
//        }
        else if isBlank(loginVCValidateObj.MobileNumberTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter mobile number." : "الرجاء إدخال رقم الجوال" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if loginVCValidateObj.MobileNumberTxtField.text!.count < 7 || loginVCValidateObj.MobileNumberTxtField.text!.count > 15 {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Mobile number must be more than 7 and less than 15 numbers only." : "يجب أن يكون رقم الجوال أكثر من 7 وأقل من 15 رقمًا فقط." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }
        else if isBlank(loginVCValidateObj.UniqueNameTxtField) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter username." : "اسم المستخدم" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if loginVCValidateObj.UniqueNameTxtField.text!.count < 3 {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Unique name should be minimum 3 characters." : "يجب أن يكون الاسم الفريد 3 أحرف على الأقل." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            loginVCValidateObj.view.endEditing(true)
            return false
        }
        else{
            return true
        }
    }
    
    
}


