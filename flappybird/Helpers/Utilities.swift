//
//  Utilities.swift
//  flappybird
//
//  Created by miray on 19.06.2020.
//  Copyright © 2020 miray. All rights reserved.
//

import Foundation
import UIKit

class Utilities {

    static func styleTextField(_ textfield:UITextField) {
            
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.white.cgColor
        textfield.borderStyle = .none
        textfield.layer.addSublayer(bottomLine)
        
}
    
    static func styleFilledButton(_ button:UIButton){
        button.backgroundColor = UIColor.red
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func sytleHollowButton(_ button:UIButton){
        
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
        
    }
    
    static func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@","^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
}
