//
//  WelcomeViewController.swift
//  flappybird
//
//  Created by miray on 15.06.2020.
//  Copyright © 2020 miray. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var LoginButton: UIButton!
    
    @IBOutlet weak var SigninButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }
    
    func setUpElements(){
        Utilities.styleFilledButton(SigninButton)
        Utilities.sytleHollowButton(LoginButton)
        
    }
    
    
}
