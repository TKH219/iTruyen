//
//  TextHelper.swift
//  iTruyen
//
//  Created by NghiaNT12 on 4/10/19.
//  Copyright © 2019 HanLTP. All rights reserved.
//

import Foundation
import UIKit
public class Helper {
    
    static var app: Helper = {
        return Helper()
    }()
    
    func checkEmail(email: String) ->Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func checkEmpty(text: String) ->Bool{
        if text.isEmpty
        {
            return true
        }
        return false
    }

    func showAlert(title: String, message:String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message,    preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        vc.present(alert, animated: true, completion: nil)
    }
}
extension String{
    var toDate: Date {
        return Date.Formatter.customDate.date(from: self)!
    }
}
extension Date{
    struct Formatter {
        static let customDate: DateFormatter = {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter
        }()
    }
}
