//
//  SigninViewController.swift
//  flappybird
//
//  Created by miray on 18.06.2020.
//  Copyright © 2020 miray. All rights reserved.
//  Kayıt ol

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore


class SigninViewController: UIViewController {

   
    
    @IBOutlet weak var UserNameTextfield: UITextField!
    
    @IBOutlet weak var EmailTextfield: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var SigninButton: UIButton!
    
    @IBOutlet weak var ErrorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
    }
    
    func setUpElements(){
        
        Utilities.styleTextField(UserNameTextfield)
        Utilities.styleTextField(EmailTextfield)
        Utilities.styleTextField(passwordTextfield)
        Utilities.styleFilledButton(SigninButton)
        
    }
    
    func validateFields() -> String? {
        
        if UserNameTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || EmailTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
        
            return "Lütfen bütün boş alanları doldurun."
            
        }
        
        
        let cleanedPassword = passwordTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanedPassword) == false {
            return "Parola yeterince güçlü değil."
        }
    
    return nil
    }
    
    @IBAction func SigninTapped(_ sender: Any) {
        
        let error = validateFields()
        
        if error != nil {
            //Hata mesajı bastırılacak.
            self.showError(error!)
        }
        
        else {
            let UserName = UserNameTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let Email = EmailTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let Password = passwordTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            //Kullanıcı oluşturulacak.
            Auth.auth().createUser(withEmail: Email, password: Password) { (results, error) in
                if error != nil {
                    self.showError("Kullanıcı oluşturuluramadı.")
                }
                
                else {
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["Email":Email, "UserName":UserName, "uid":results!.user.uid]) { (error) in
                        if error != nil {
                            self.showError("Kullanıcı verileri kaydedilirken hata oluştu.")
                        }
                    }
                    
                    self.transitionToStart()
                }
            }
        }
    }
    
    func showError(_ message:String) {
        ErrorLabel.text = message
        ErrorLabel.alpha = 1
    }
    
    func transitionToStart(){
        let startViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.startViewController) as! StartViewController
        
        view.window?.rootViewController = startViewController
        view.window?.makeKeyAndVisible()
        
    }
}
