//
//  LoginViewController.swift
//  InstaClone
//
//  Created by Michael A on 2017-08-22.
//  Copyright © 2017 AI Labs. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
class LoginViewController: UIViewController {
    
    fileprivate let pastelView:PastelView = {
        let pastelView = PastelView()
        pastelView.animationDuration = 3
        pastelView.setPastelGradient(.winterNeva)
        pastelView.startPastelPoint = .left
        pastelView.endPastelPoint = .right
        pastelView.startAnimation()
        return pastelView
    }()
    

    lazy var headerLabelImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "Instagram_logo_white")
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 40
        iv.layer.masksToBounds = true
        return iv
    }()
    
    fileprivate lazy var emailTextField:UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email or username"
        textField.font = UIFont.systemFont(ofSize: 12)
        textField.keyboardType = .emailAddress
        textField.borderStyle = .roundedRect
        textField.addTarget(self, action: #selector(handleTextFieldEditing), for: .editingChanged)
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        return textField
    }()
    
    
    fileprivate lazy var passwordLoginTextField:UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.font = UIFont.systemFont(ofSize: 12)
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(handleTextFieldEditing), for: .editingChanged)
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        return textField
    }()
    
    fileprivate lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = true
        button.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        button.addTarget(self, action: #selector(loginButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    fileprivate lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign up", for: .normal)
        let color = UIColor.rgb(red: 96, green: 177, blue: 255)
        button.setTitleColor(color, for: UIControlState.normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        return button
    }()
    fileprivate let bottomSeparatorLineView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 0.8)
        return view
    }()
    fileprivate let leftSeparatorLineView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 0.8)
        return view
    }()
    fileprivate let rightSeparatorLineView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 0.8)
        return view
    }()
    fileprivate let orLabel: UILabel = {
        let label = UILabel()
        label.text = "OR"
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textColor = .lightGray
        return label
    }()
    fileprivate let noAccountLabel: UILabel = {
        let label = UILabel()
        label.text = "Don't have an account?"
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .lightGray
        return label
    }()
 
    fileprivate lazy var getHelpSignInButton: UIButton = {
        let button = UIButton()
        let forgotAttributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 10), NSForegroundColorAttributeName: UIColor.lightGray]
        let attributedText = NSMutableAttributedString(attributedString: NSAttributedString.init(string: "Forgot your login details?", attributes: forgotAttributes))
        let attributes = [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 10), NSForegroundColorAttributeName: UIColor.rgb(red: 96, green: 177, blue: 255)]
        attributedText.append(NSAttributedString.init(string: "Get help signing in.", attributes: attributes))
        button.setAttributedTitle(attributedText, for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.textAlignment = .center
        return button
    }()
    fileprivate lazy var facebookLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In With Facebook", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0)
        button.setImage(#imageLiteral(resourceName: "facebookIcon"), for: .normal)
        button.setTitleColor(UIColor.rgb(red: 96, green: 177, blue: 255), for: .normal)
        button.addTarget(self, action: #selector(loginButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleTextFieldEditing() {
        let isFormValid = emailTextField.text?.characters.count ?? 0 > 0   && passwordLoginTextField.text?.characters.count ?? 0 > 0
        if isFormValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        }
    }
    
    @objc private func loginButtonTapped(_ sender:UIButton) {
        
        SVProgressHUD.show()
        
        guard let email = emailTextField.text, email.characters.count > 0, let password = passwordLoginTextField.text, password.characters.count > 0 else {
            return
        }
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error!.localizedDescription);
                SVProgressHUD.dismiss()
                return
            }
            
             let maintabBarController = MainTabController()
          
            self.present(maintabBarController, animated: true, completion: {
                SVProgressHUD.dismiss()

            })
        })
    }
    
    @objc private func signUpButtonTapped() {
        self.present(SignUpViewController(), animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(pastelView)
        view.addSubview(headerLabelImageView)
        view.addSubview(bottomSeparatorLineView)
        view.addSubview(noAccountLabel)
        view.addSubview(signUpButton)
        view.addSubview(getHelpSignInButton)
        view.addSubview(facebookLoginButton)
        view.addSubview(leftSeparatorLineView)
        view.addSubview(orLabel)
        view.addSubview(rightSeparatorLineView)
        
        
        let headerHeight = view.frame.height / 5
        pastelView.anchorConstraints(topAnchor: view.topAnchor, topConstant: 0, leftAnchor: view.leftAnchor, leftConstant: 0, rightAnchor: view.rightAnchor, rightConstant: 0, bottomAnchor: nil, bottomConstant: 0, heightConstant: headerHeight, widthConstant: 0)
        pastelView.anchorConstraints(topAnchor: view.topAnchor, topConstant: 0, leftAnchor: view.leftAnchor, leftConstant: 0, rightAnchor: view.rightAnchor, rightConstant: 0, bottomAnchor: nil, bottomConstant: 0, heightConstant: headerHeight, widthConstant: 0)
        headerLabelImageView.anchorCenterConstraints(centerXAnchor: pastelView.centerXAnchor, xConstant: 0, centerYAnchor: pastelView.centerYAnchor, yConstant: 0)
        
        
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordLoginTextField,loginButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
            stackView.topAnchor.constraint(equalTo: pastelView.bottomAnchor, constant: 30),
            stackView.heightAnchor.constraint(equalToConstant: 150)
            ])
        
        getHelpSignInButton.anchorConstraints(topAnchor: stackView.bottomAnchor, topConstant: 10, leftAnchor: loginButton.leftAnchor, leftConstant: 4, rightAnchor: loginButton.rightAnchor, rightConstant: -4, bottomAnchor: nil, bottomConstant: 0, heightConstant: 0, widthConstant: 0)
        
        bottomSeparatorLineView.anchorConstraints(topAnchor: nil, topConstant: 0, leftAnchor: view.leftAnchor, leftConstant: 0, rightAnchor: view.rightAnchor, rightConstant: 0, bottomAnchor: view.bottomAnchor, bottomConstant: -40, heightConstant: 0.5, widthConstant: 0)
        noAccountLabel.anchorCenterConstraints(centerXAnchor: view.centerXAnchor, xConstant: -30, centerYAnchor: nil, yConstant: 0)
        noAccountLabel.anchorConstraints(topAnchor: nil, topConstant: 0, leftAnchor: nil, leftConstant: 0, rightAnchor: nil, rightConstant: 0, bottomAnchor: view.bottomAnchor, bottomConstant: -15, heightConstant: 0, widthConstant: 0)
        
        signUpButton.anchorConstraints(topAnchor: nil, topConstant: 0, leftAnchor: noAccountLabel.rightAnchor, leftConstant: 5, rightAnchor: nil, rightConstant: 0, bottomAnchor: view.bottomAnchor, bottomConstant: -9, heightConstant: 0, widthConstant: 0)
        
        facebookLoginButton.anchorConstraints(topAnchor: nil, topConstant: 0, leftAnchor: view.leftAnchor, leftConstant: 50, rightAnchor: view.rightAnchor, rightConstant: -50, bottomAnchor: bottomSeparatorLineView.topAnchor, bottomConstant: -40, heightConstant: 0, widthConstant: 0)
        
        leftSeparatorLineView.anchorConstraints(topAnchor: getHelpSignInButton.bottomAnchor, topConstant: 30, leftAnchor: view.leftAnchor, leftConstant: 40, rightAnchor: orLabel.leftAnchor, rightConstant: -20, bottomAnchor: nil, bottomConstant: 0, heightConstant: 0.5, widthConstant: 0)
        
        orLabel.anchorConstraints(topAnchor: getHelpSignInButton.bottomAnchor, topConstant: 24, leftAnchor: nil, leftConstant: 0, rightAnchor: nil, rightConstant: 0, bottomAnchor: nil, bottomConstant: 0, heightConstant: 0, widthConstant: 0)
        orLabel.anchorCenterConstraints(centerXAnchor: view.centerXAnchor, xConstant: 0, centerYAnchor: nil, yConstant: 0)
        
        rightSeparatorLineView.anchorConstraints(topAnchor: getHelpSignInButton.bottomAnchor, topConstant: 30, leftAnchor: orLabel.rightAnchor, leftConstant: 20, rightAnchor: view.rightAnchor, rightConstant: -40, bottomAnchor: nil, bottomConstant: 0, heightConstant: 0.5, widthConstant: 0)
    }
}


















