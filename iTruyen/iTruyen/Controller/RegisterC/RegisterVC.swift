//
//  RegisterVC.swift
//  iTruyen
//
//  Created by NghiaNT12 on 4/10/19.
//  Copyright © 2019 HanLTP. All rights reserved.
//

import UIKit
import Firebase
import SkyFloatingLabelTextField
class RegisterVC: UIViewController {
    
    @IBOutlet weak var txtName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtUserID: SkyFloatingLabelTextField!
    @IBOutlet weak var txtPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var txtRepassword: SkyFloatingLabelTextField!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var btnRegister: UIButton!
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
        txtName.placeholder = "Fullname"
        txtName.title = "Họ và Tên"
        txtUserID.placeholder = "Email"
        txtUserID.title = "Tài khoản email"
        txtPassword.placeholder = "Password"
        txtPassword.title = "Mật khẩu"
        txtRepassword.placeholder = "Repassword"
        txtRepassword.title = "Mật khẩu"
        
    }
    func customButton()
    {
        self.btnRegister.applyGradient(colors: [UIColor(red: 73/255, green: 158/255, blue: 255/255, alpha: 1).cgColor, UIColor.cyan.cgColor])
        self.btnRegister.layer.cornerRadius = 10
    }
    @IBAction func didTapRegister(_ sender: Any) {
        let textEmail  = txtUserID.text
        let textPassword = txtPassword.text
        let textRepassword = txtRepassword.text
        let textUsername = txtName.text
        if !Helper.app.checkEmail(email: textEmail!)
        {
            Helper.app.showAlert(title: "Cảnh báo!", message: "Vui lòng nhập chính xác email", vc: self)
        }
        else if (Helper.app.checkEmpty(text: textPassword!) ||
            Helper.app.checkEmpty(text: textRepassword!) ||
            Helper.app.checkEmpty(text: textEmail!) ||
            Helper.app.checkEmpty(text: textUsername!) )
        {
            Helper.app.showAlert(title: "Cảnh báo!", message: "Vui lòng không bỏ trống", vc: self)
        }
        else if (textPassword != textRepassword)
        {
            Helper.app.showAlert(title: "Cảnh báo!", message: "Mật khẩu nhập lại không trùng", vc: self)
        }
        else if ((textPassword?.count)! < 7)
        {
            Helper.app.showAlert(title: "Cảnh báo!", message: "Mật khẩu phải lớn hơn 7 kí tự", vc: self)
        }
        else
        {
            Auth.auth().createUser(withEmail: textEmail!, password: textPassword!) { authResult, error in
                if error == nil
                {
                   
                    self.addUserToDatabase(uid: (Auth.auth().currentUser?.uid)!)
                    Helper.app.showAlert(title: "Thông báo!", message: "Đăng ký thành công", vc: self)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.navigationController?.popViewController(animated: true)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                else
                {
                    Helper.app.showAlert(title: "Thông báo!", message: "Đăng ký thất bại", vc: self)
                }
            }
        }
    }
    func addUserToDatabase(uid: String)
    {
        let newUser = User()
        newUser.Id = uid
        newUser.Name = txtName.text
        newUser.saveToFirebase()
        try! Auth.auth().signOut()
    }
    @IBAction func didTapHaveAccount(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
