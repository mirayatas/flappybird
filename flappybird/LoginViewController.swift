//
//  LoginViewController.swift
//  flappybird
//
//  Created by miray on 18.06.2020.
//  Copyright © 2020 miray. All rights reserved.
//

import UIKit //Giriş Yap
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var EmailTextfield: UITextField!
    
    @IBOutlet weak var Passwordtextfield: UITextField!
    
    @IBOutlet weak var LoginButton: UIButton!
    
    @IBOutlet weak var ErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
    }
    
    func setUpElements(){
        
        Utilities.styleTextField(EmailTextfield)
        Utilities.styleTextField(Passwordtextfield)
        Utilities.styleFilledButton(LoginButton)
    }

    @IBAction func LoginTapped(_ sender: Any) {
        // Kullanıcı girişi
        let Email = EmailTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let Password = Passwordtextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().signIn(withEmail: Email, password: Password) { (result, error) in
            if error != nil {
                self.ErrorLabel.text = error!.localizedDescription
                self.ErrorLabel.alpha = 1
            }
            else {
                let startViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.startViewController) as? StartViewController
                
                self.view.window?.rootViewController = startViewController
                
            }
        }
    }
}
