//
//  ViewController.swift
//  UserPosts
//
//  Created by Robert Rozenvasser on 3/27/17.
//  Copyright © 2017 Robert Rozenvasser. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var signUpButtonBottomConstraint: NSLayoutConstraint!
    var textFieldPressedCounter = 1
    
    let nameTextField: TextField = {
        let tf = TextField()
        tf.placeholder = "Name"
        tf.backgroundColor = Palette.lightGrey.color
        tf.layer.cornerRadius = 4.0
        tf.layer.masksToBounds = true
        tf.font = UIFont(name: "Avenir-Medium", size: 14.0)
        tf.textColor = Palette.grey.color
        return tf
    }()
    
    let emailTextField: TextField = {
        let tf = TextField()
        tf.placeholder = "Email"
        tf.backgroundColor = Palette.lightGrey.color
        tf.layer.cornerRadius = 4.0
        tf.layer.masksToBounds = true
        tf.font = UIFont(name: "Avenir-Medium", size: 14.0)
        tf.textColor = Palette.grey.color
        return tf
    }()
    
    let passwordTextField: TextField = {
        let tf = TextField()
        tf.placeholder = "Password"
        tf.backgroundColor = Palette.lightGrey.color
        tf.layer.cornerRadius = 4.0
        tf.layer.masksToBounds = true
        tf.font = UIFont(name: "Avenir-Medium", size: 14.0)
        tf.textColor = Palette.grey.color
        return tf
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Palette.aqua.color
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 14.0)
        button.layer.cornerRadius = 4.0
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFieldsAndSignUpButton()
        view.backgroundColor = UIColor.white
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Login diassapered")
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func handleSignUp() {
        
        guard let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else { print("Form is not valid"); return }
        
        FirebaseManager.createNewUser(name: name, email: email, password: password) { (didCreateUser) in
            
            UserDefaults.standard.set(name, forKey: "userName")
            UserDefaults.standard.set(email, forKey: "userEmail")
            
            if didCreateUser {
                self.dismiss(animated: true, completion: nil)
            } else {
                //Show alert
            }
            
        }
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func setupTextFieldsAndSignUpButton() {
        let textFields = [nameTextField, emailTextField, passwordTextField]
        
        for textField in textFields {
            textField.delegate = self
        }
        
        let stackView = UIStackView(arrangedSubviews: textFields)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        
        view.addSubview(signUpButton)
        view.addSubview(stackView)
        
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30.0).isActive = true
        signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30.0).isActive = true
        self.signUpButtonBottomConstraint = signUpButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -98.0)
        signUpButtonBottomConstraint .isActive = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30.0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30.0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -10.0).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 155).isActive = true
    }

    func keyboardWillShow(_ notification:Notification) {
        if textFieldPressedCounter <= 1 {
            adjustingHeight(true, notification: notification)
            textFieldPressedCounter += 1
        }
    }
    
    func keyboardWillHide(_ notification:Notification) {
        if textFieldPressedCounter != 1 {
            adjustingHeight(false, notification: notification)
            textFieldPressedCounter = 1
        }
    }
    
    func adjustingHeight(_ show:Bool, notification:Notification) {
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let changeInHeight = (keyboardFrame.height - 40) * (show ? -1 : 1)
        self.signUpButtonBottomConstraint.constant += changeInHeight
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
