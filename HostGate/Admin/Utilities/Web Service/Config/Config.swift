//
//  Config.swift
//  Receipt Catcher
//
//  Created by tarun-mac-6 on 04/03/19.
//  Copyright © 2019 Tarun Nagar. All rights reserved.
//

import UIKit

class Config: NSObject {
   // let API_URL = "http://i.devtechnosys.tech:8083/hostgates/Webservices/"
     let API_URL = "https://hostgates.co/Webservices/"
    
    
    let API_Login = "login"
    let API_ForgotNamePasword = "forgotUsernamePassword"
    let API_ResendOtp = "resendForgotOtp"
    let API_VerifyOtp = "verifyOtp"
    let API_ResetPassword = "resetPassword"
    let API_ChangePassword = "changePassword"
    let API_GetUserProfile = "getUserProfile"
    let API_UpdateUserProfile = "updateProfile"
    let API_Dashboard = "dashboard"
    let API_GetCountry = "getCountry"
    let API_getBusinessDetail = "getBusinessProfile"
    let API_UpdateBusinessDetail = "updateBusiness"
    let API_AddCommunity = "addCommunity"
    let API_GetCommunityData = "getCommunityData"
    let API_UpdateCommunity = "updateCommunity"
    let API_GetAllCommunity = "getAllCommunity"
    let API_DeleteCommunity = "deleteCommunity"
    let API_AddStaff = "addStaff"
    let API_GetAllStaff = "getAllStaff"
    let API_SendMessage = "sendMessageUser"
    let API_CreateSupportTickets = "supportTicket"
    let API_AddSubscriptionPlan = "addSubscriptions"
    let API_SubscriptionList = "subscriptions"
    let API_VisitorTypeList = "visitorTypes"
    let API_AddVisitors = "addVisitorTypes"
    let API_GetVisitorTypes = "getVisitorTypes"
    let API_UpdateVisitorType = "updateVisitorTypes"
    let API_DeleteVisitorType = "deleteVisitorTypes"
    let API_GetPrice = "getPricing"
    let API_UpdateAutorenewal = "updateAutoRenewal"
    let API_SunAccountList = "subaccount"
    let API_AddSubAccount = "addSubaccount"
    let API_GetSubAccount = "getSubaccount"
    let API_UpdateSubAccount = "updateSubaccount"
    let API_DeleteSubAccount = "deleteSubaccount"
    let API_VisitorTypeListByUserID = "visitorsTypeListbyUserId"
    let API_UserVisitorList = "visitors"
    let API_UserAddVisitors = "addVisitors"
    let API_UserGetVisitors = "getVisitors"
    let API_UserUpdateVisitors = "updateVisitors"
    let API_UserDeleteVisitors = "deleteVisitors"
    let API_UserCancleVisitors = "cancelVisitors"
    let API_UserSendOtpVisitors = "sendOtpVisitors"
    let API_UserHostPass = "hostPass"
    let API_PropertyList = "propertyList"
    let API_AddReverseVisitor = "addReverseVisitors"
    let API_ReverseVisitorList = "reverseVisitorsList"
    let API_GateVisitorList = "gateVisitorsList"
    let API_AcceptRejectVisitor = "acceptRejectVisitors"
    let API_CheckOut = "checkOutVisitor"
    let API_GateVisitorDetail = "getVisitorDetail"
    let API_FreeAccount = "freeAccounts"
    let API_CheckAccountStatus = "checkAccountStatus"
    let API_DownloadInvoice = "downloadInvoice"
    let API_GetAllVisList = "getAllVisitorsList"
    let API_Reporting = "reports"
    let API_UserAccountDetails = "getPropertyData"
    let API_ApplyCoupen = "applyCoupon"
    let API_RenewSubscription =  "renewSubscription"
    let API_VerifyRenewPayment = "verifyRenewPayment"
    let API_GetDeviceList = "getDevices"
    let API_Logout = "logout"
    
    let AppAlertTitle = "HostGates"
    let AppUserDefaults = UserDefaults.standard
    
    let debug_mode = 1
    let NO_IMAGE = "NoImage"
    
    let USER_NO_IMAGE = "NoImage"
    var shownIndexes : [IndexPath] = []
    let CELL_HEIGHT : CGFloat = 40
    
    
    /********************************* App Color Codes ***************************************/
    let AppBackgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
    let AppNavBlueColor = UIColor(red: 0/255, green: 188/255, blue: 252/255, alpha: 1.0)
    let AppGreenColor = UIColor(red: 44/255, green: 175/255, blue: 125/255, alpha: 1.0)
    let AppYellowColor = UIColor(red: 255/255, green: 242/255, blue: 63/255, alpha: 1.0)
    let AppBrownColor = UIColor(red: 231/255, green: 149/255, blue: 41/255, alpha: 1.0)
    let AppButtonGreenColor = UIColor(red: 70/255, green: 147/255, blue: 155/255, alpha: 1.0)
    let AppLineColor = UIColor.lightText
    let AppGrayColor = UIColor(white: 0xDCDCDC, alpha: 1.0)
    let AppBlackColor = UIColor.black
    let AppRedColor = UIColor(red: 233/255, green: 62/255, blue: 39/255, alpha: 1.0)
    let AppAppleColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1.0)
    
    let AppWhiteColor = UIColor.white
    let AppClearColor = UIColor.clear
    
    func printData(_ dataValue : Any ){
        if debug_mode == 1 {
            print(dataValue)
        }
    }
    
    
}
