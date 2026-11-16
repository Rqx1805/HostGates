//
//  CustomTxtField.swift
//  HostGate
//
//  Created by Vipul on 01/04/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import Foundation
import UIKit  // don't forget this

class CustomUITextField: UITextField {
     func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
