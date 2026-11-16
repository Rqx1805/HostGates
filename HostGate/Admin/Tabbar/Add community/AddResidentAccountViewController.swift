//
//  AddResidentAccountViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 22/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class AddResidentAccountViewController: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var buliding_numberTxt: UITextField!
    @IBOutlet weak var unit_numberTxt: UITextField!
    @IBOutlet weak var assign_gateTxt: UITextField!
    @IBOutlet weak var owner_nameTxt: UITextField!
    @IBOutlet weak var national_idTxt: UITextField!
    @IBOutlet weak var NationalityTxt: UITextField!
    @IBOutlet weak var email_addressTxt: UITextField!
    @IBOutlet weak var mobile_numberTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func submitBtbAction(_ sender: Any) {
    }
    
}
