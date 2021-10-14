//
//  SignInController.swift
//  Near
//
//  Created by Bhushan Mahajan on 27/09/21.
//

import UIKit

class SignInController: UIViewController {
    
    //MARK: - Properties/Variables
    
    //Activity indicator instance to use the loading animation.
    let activityIndicator = ActivityIndicator()
    
    //All the elements used in sign in page are configured using anonymous closure pattern
    let passPhraseContainer = UIView()
    let passPhraseTextField: UITextField = {
        let tf = UITextField()
        tf.StyleTextField(placeholder: "Enter PassPhrase", isSecureText: false)
        return tf
    }()
    let passPhraseLogo: UIImage! = {
        let button = UIImage(systemName: "signature")?.withTintColor(.link, renderingMode: .alwaysOriginal)
        return button
    }()
    var nearLogo: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "nearLogoWhite")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .link
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 10
        return button
    }()
    
    //MARK: - Init Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSignInController()
    }
    
    //MARK: - Configuration Functions
    
    func configureSignInController() {
        //Navigation bar configuration
        navigationItem.title = "Sign In"
        
        //Background color for the page
        view.backgroundColor = UIColor.grey()
        
        //constraints for the Near logo
        view.addSubview(nearLogo)
        nearLogo.anchor(top: view.topAnchor, paddingTop: 80, width: 250, height: 250)
        nearLogo.translatesAutoresizingMaskIntoConstraints = false
        nearLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        //constraints for the passphrase textfield
        view.addSubview(passPhraseContainer)
        passPhraseContainer.anchor(left: view.leftAnchor, paddingLeft: 32, right: view.rightAnchor, paddingRight: 32, height: 45)
        passPhraseContainer.translatesAutoresizingMaskIntoConstraints = false
        passPhraseContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        passPhraseContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passPhraseContainer.textContainerView(view: passPhraseContainer, image: passPhraseLogo, textField: passPhraseTextField)
        
        //constraints for the Sign in button
        view.addSubview(signInButton)
        signInButton.anchor(top: passPhraseTextField.bottomAnchor, paddingTop: 35, width: 200, height: 45)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        //constraints for the Loading animation
        view.addSubview(activityIndicator)
        activityIndicator.anchor(top: signInButton.bottomAnchor, paddingTop: 30, width: 150, height: 40)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    //MARK: - Helper Functions
    
    //Function used to naviagte to home screen.
    func showHomeController() {
        let vc = HomeController()
        navigationController?.setViewControllers([vc], animated: true)
    }
    
    //Function used for showing alert message.
    func showAlert(title: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Selector Functions
    
    
    @objc func signInButtonTapped() {
        
        //Checking the passphrase is not nil and the textfield is not empty
        guard let passPhrase = passPhraseTextField.text, !passPhrase.isEmpty else { return }
       
        //Loading animation initiated
        activityIndicator.animate()
       
        //Sign In User function called from NearRestApi file.
        NearRestAPI.shared.signInUser(passPhrase: passPhrase) { result in
            
            //using the main thread for executing the closure as it contains ui elements.
            DispatchQueue.main.async {
                switch result {
                
                    //if the reult is success for the completion of the function
                case .success(let response):
                    
                    //if the result from server is success
                    if response.success == true {
                        
                        //loading animation removed
                        self.activityIndicator.removeFromSuperview()
                        
                        //navigate to home screen
                        self.showHomeController()
                       
                        //Saving the accountname, privatekey and publickey in userdefaults for later use.
                        UserDefaults.standard.set(response.accountName, forKey: Constants.nearAccountName.rawValue)
                        UserDefaults.standard.set(response.privateKey, forKey: Constants.nearPrivateKey.rawValue)
                        UserDefaults.standard.set(response.publicKey, forKey: Constants.nearPublicKey.rawValue)
                  
                        //if the result from server is false
                    } else if response.success == false {
                        
                        //loading animation removed
                        self.activityIndicator.removeFromSuperview()
                       
                        //Show alert message for error message
                        self.showAlert(title: "Error", message: "Account does not exist. Please check your PassPhrase and try again !", actionTitle: "ok")
                    }
               
                    //if the reult is failure for the completion of the function
                case .failure(let error):
                    
                    //loading animation removed
                    self.activityIndicator.removeFromSuperview()
                    
                    //Show alert message for error message
                    self.showAlert(title: "Error", message: error.localizedDescription, actionTitle: "ok")
                }
            }
        }
    }
}
