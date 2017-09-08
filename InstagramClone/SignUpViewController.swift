//
//  SignUpViewController.swift
//  InstaClone
//
//  Created by Michael A on 2017-08-23.
//  Copyright © 2017 AI Labs. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SVProgressHUD

class SignUpViewController: UIViewController {
   
    fileprivate let pastelView:PastelView = {
        let pastelView = PastelView()
        pastelView.animationDuration = 3
        pastelView.setPastelGradient(.winterNeva)
        pastelView.startPastelPoint = .left
        pastelView.endPastelPoint = .right
        pastelView.startAnimation()
        return pastelView
    }()
    
    
    fileprivate let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let attributes = [NSFontAttributeName:UIFont.init(name: "Pacifico-Regular", size: 45), NSForegroundColorAttributeName: UIColor.white]
        let headerLabelAttributedText = NSAttributedString(string: "InstaClone", attributes: attributes)
        label.attributedText = headerLabelAttributedText
        return label
    }()
    
    fileprivate lazy var emailTextField:UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.font = UIFont.systemFont(ofSize: 12)
        textField.keyboardType = .emailAddress
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.addTarget(self, action: #selector(handleTextFieldEditing), for: .editingChanged)
        return textField
    }()
    fileprivate lazy var userNameTextField:UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.font = UIFont.systemFont(ofSize: 12)
        textField.keyboardType = .emailAddress
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.addTarget(self, action: #selector(handleTextFieldEditing), for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var passwordLoginTextField:UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.font = UIFont.systemFont(ofSize: 12)
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.addTarget(self, action: #selector(handleTextFieldEditing), for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = true
        button.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        button.isEnabled = false
        button.addTarget(self, action: #selector(signUpButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    fileprivate let alreadyHaveAnAccount: UILabel = {
        let label = UILabel()
        label.text = "Already have an account?"
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .lightGray
        return label
    }()
    fileprivate lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.setTitleColor(UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var userImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "person-placeholder")
        iv.backgroundColor = .blue
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 50
        iv.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectUserImageButtonTapped(_:)))
        iv.addGestureRecognizer(tapGestureRecognizer)
        return iv
    }()
    fileprivate lazy var addProfileImageButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "add"), for: .normal)
        button.addTarget(self, action: #selector(selectUserImageButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    fileprivate let bottomSeparatorLineView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 0.8)
        return view
    }()
    
  
    @objc private func selectUserImageButtonTapped(_ sender:UIButton){
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc private func handleTextFieldEditing() {
        let isFormValid = emailTextField.text?.characters.count ?? 0 > 0  && userNameTextField.text?.characters.count  ?? 0 >  0 && passwordLoginTextField.text?.characters.count ?? 0 > 0
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        }
    }
    
    @objc private func signUpButtonTapped(_ sender:UIButton) {
        
        SVProgressHUD.show()
      
        guard let email = emailTextField.text, email.characters.count > 0  else { return }
        guard let username = userNameTextField.text, username.characters.count > 0 else { return }
        guard let password = passwordLoginTextField.text, password.characters.count > 0 else { return }
        Auth.auth().createUser(withEmail: email, password: password, completion: { [unowned self](user, error)  in
            if error != nil { print(error!.localizedDescription); SVProgressHUD.dismiss(); return }
            guard let selectedUserImage = self.userImageView.image else {
                return
            }
            guard let compressedUserImage = UIImageJPEGRepresentation(selectedUserImage, 0.1) else {
                return
            }
            let uniqueIdentifier = UUID().uuidString
            firebaseStorageReference.child("User_Profile_Images").child(uniqueIdentifier).putData(compressedUserImage, metadata: nil, completion: { (metadata, error) in
                if error != nil { print(error!.localizedDescription); SVProgressHUD.dismiss(); return}
                guard let profileImageUrl = metadata?.downloadURL()?.absoluteString else {return }
                guard let userId = user?.uid else {return}
                let userDictionaryValues:[String:Any] = ["username":username,"profileImageUrl":profileImageUrl]
                let values = [userId:userDictionaryValues]
                firebaseDatabaseReference.child("users").updateChildValues(values) { (error, reference) in
                    if error != nil { print(error!.localizedDescription); SVProgressHUD.dismiss();return}
                }
            })
            
        })
        
        let mainTabBarController = MainTabController()
        self.present(mainTabBarController, animated: true) { 
            SVProgressHUD.dismiss()
        }
        
    }
    
    @objc private func loginButtonTapped() {
        self.present(LoginViewController(), animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(pastelView)
        view.addSubview(userImageView)
        view.addSubview(addProfileImageButton)
        view.addSubview(headerLabel)
        view.addSubview(bottomSeparatorLineView)
        view.addSubview(loginButton)
        view.addSubview(alreadyHaveAnAccount)
        
        
        let headerHeight = view.frame.height / 5
        pastelView.anchorConstraints(topAnchor: view.topAnchor, topConstant: 0, leftAnchor: view.leftAnchor, leftConstant: 0, rightAnchor: view.rightAnchor, rightConstant: 0, bottomAnchor: nil, bottomConstant: 0, heightConstant: headerHeight, widthConstant: 0)
        headerLabel.anchorCenterConstraints(centerXAnchor: pastelView.centerXAnchor, xConstant: 0, centerYAnchor: pastelView.centerYAnchor, yConstant: 0)
        
        userImageView.anchorConstraints(topAnchor: pastelView.bottomAnchor, topConstant: 30, leftAnchor: nil, leftConstant: 0, rightAnchor: nil, rightConstant: 0, bottomAnchor: nil, bottomConstant: 0, heightConstant: 100, widthConstant: 100)
        userImageView.anchorCenterConstraints(centerXAnchor: view.centerXAnchor, xConstant: 0, centerYAnchor: nil, yConstant: 0)
        
        addProfileImageButton.anchorConstraints(topAnchor: nil, topConstant: 0, leftAnchor: nil, leftConstant: 0, rightAnchor: userImageView.rightAnchor, rightConstant: 2, bottomAnchor: userImageView.bottomAnchor, bottomConstant: 2, heightConstant: 30, widthConstant: 30)
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, userNameTextField, passwordLoginTextField,signUpButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
            stackView.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 30),
            stackView.heightAnchor.constraint(equalToConstant: 200)
            ])
        
        
        bottomSeparatorLineView.anchorConstraints(topAnchor: nil, topConstant: 0, leftAnchor: view.leftAnchor, leftConstant: 0, rightAnchor: view.rightAnchor, rightConstant: 0, bottomAnchor: view.bottomAnchor, bottomConstant: -40, heightConstant: 0.5, widthConstant: 0)
        alreadyHaveAnAccount.anchorCenterConstraints(centerXAnchor: view.centerXAnchor, xConstant: -30, centerYAnchor: nil, yConstant: 0)
        alreadyHaveAnAccount.anchorConstraints(topAnchor: nil, topConstant: 0, leftAnchor: nil, leftConstant: 0, rightAnchor: nil, rightConstant: 0, bottomAnchor: view.bottomAnchor, bottomConstant: -15, heightConstant: 0, widthConstant: 0)
        
        loginButton.anchorConstraints(topAnchor: nil, topConstant: 0, leftAnchor: alreadyHaveAnAccount.rightAnchor, leftConstant: 5, rightAnchor: nil, rightConstant: 0, bottomAnchor: view.bottomAnchor, bottomConstant: -9, heightConstant: 0, widthConstant: 0)
    }
}

extension SignUpViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            userImageView.image = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            userImageView.image = originalImage
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}






