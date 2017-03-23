//
//  SettingsViewController.swift
//  MoviesLib
//
//  Created by Usuário Convidado on 22/03/17.
//  Copyright © 2017 EricBrito. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var swColor: UISwitch!
    @IBOutlet weak var tfName: UITextField!
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (UserDefaults.standard.bool(forKey: "color")) {
            view.backgroundColor = .white
        } else {
            view.backgroundColor = .yellow
        }
        
        if let name = UserDefaults.standard.string(forKey: "name") {
            tfName.text = name
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder() // Temos que dar um override para tornar first responder
    }
    
    @IBAction func changeColor(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "color")
    }

}

extension SettingsViewController: UITextFieldDelegate {
    // When finishes edition typing
    func textFieldDidEndEditing(_ textField: UITextField) {
        UserDefaults.standard.set(tfName.text, forKey: "name")
    }
}





