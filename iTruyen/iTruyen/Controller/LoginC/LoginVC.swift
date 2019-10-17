//
//  ViewController.swift
//  iTruyen
//
//  Created by HanLTP on 4/9/19.
//  Copyright © 2019 HanLTP. All rights reserved.
//

import UIKit
import Firebase
import SkyFloatingLabelTextField
class LoginVC : UIViewController {

    @IBOutlet weak var txtUsername: SkyFloatingLabelTextField!
    @IBOutlet weak var txtPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var secondView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        customUIView()
        customTextField()
        customButton()
    
    }
    func customUIView()
    {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.jpg")!)
        secondView.layer.cornerRadius = 20
    }
    func customTextField()
    {
        txtUsername.placeholder = "Email"
        txtUsername.title = "Tài khoản email"
        txtPassword.placeholder = "Password"
        txtPassword.title = "Mật khẩu"
    }
    func customButton()
    {
        self.btnLogin.applyGradient(colors: [UIColor(red: 73/255, green: 158/255, blue: 255/255, alpha: 1).cgColor, UIColor.cyan.cgColor])
        self.btnLogin.layer.cornerRadius = 10
    }
    
    @IBAction func didTapLogin(_ sender: Any) {
        let textEmail  = txtUsername.text
        let textPassword = txtPassword.text
        if !Helper.app.checkEmail(email: textEmail!)
        {
            Helper.app.showAlert(title: "Cảnh báo!", message: "Vui lòng nhập chính xác email", vc: self)
        }
        else if (Helper.app.checkEmpty(text: textEmail!) || Helper.app.checkEmpty(text: textPassword!))
        {
            Helper.app.showAlert(title: "Cảnh báo!", message: "Vui lòng không bỏ trống", vc: self)
        }
        else
        {
            Auth.auth().signIn(withEmail: textEmail!, password: textPassword!) { authResult, error in
                if error == nil
                {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil);
                    let tabbar = storyboard.instantiateViewController(withIdentifier: "idTabBarController") as! UITabBarController
                    self.present(tabbar, animated: true, completion: nil)
                 
                    
                }
                else
                {
                   Helper.init().showAlert(title: "Thông báo!", message: "Sai tài khoản hoặc mật khẩu", vc: self)
                }
            }
        }
    }

    @IBAction func didTapRegister(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let registerVC = storyboard.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        self.present(registerVC, animated: true, completion: nil);
    }
}
extension UIButton
{
    func applyGradient(colors: [CGColor])
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = self.bounds
        self.layer.addSublayer(gradientLayer)
    }
}
