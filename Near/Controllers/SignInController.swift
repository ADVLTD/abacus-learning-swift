//
//  SignInController.swift
//  Near
//
//  Created by Bhushan Mahajan on 27/09/21.
//

import UIKit

class SignInController: UIViewController {
    
    //MARK: - Properties/Variables
    
    let near = NearRestAPI()
    let activityIndicator = ActivityIndicator()
    
    let passPhraseTextField: UITextField = {
        let tf = UITextField()
        tf.StyleTextField(placeholder: "Enter PassPhrase", isSecureText: false)
        return tf
    }()
    let passPhraseContainer = UIView()
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
        view.backgroundColor = UIColor.grey()
        
        navigationItem.title = "Sign In"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        view.addSubview(nearLogo)
        nearLogo.anchor(top: view.topAnchor, paddingTop: 80, width: 250, height: 250)
        nearLogo.translatesAutoresizingMaskIntoConstraints = false
        nearLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(passPhraseContainer)
        passPhraseContainer.anchor(left: view.leftAnchor, paddingLeft: 32, right: view.rightAnchor, paddingRight: 32, height: 45)
        passPhraseContainer.translatesAutoresizingMaskIntoConstraints = false
        passPhraseContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        passPhraseContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passPhraseContainer.textContainerView(view: passPhraseContainer, image: passPhraseLogo, textField: passPhraseTextField)
        
        view.addSubview(signInButton)
        signInButton.anchor(top: passPhraseTextField.bottomAnchor, paddingTop: 35, width: 200, height: 45)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(activityIndicator)
        activityIndicator.anchor(top: signInButton.bottomAnchor, paddingTop: 30, width: 150, height: 40)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    //MARK: - Helper Functions
    
    func showHomeController() {
        let vc = HomeController()
        navigationController?.setViewControllers([vc], animated: true)
    }
    
    func showAlert(title: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Objc Functions
    
    @objc func signInButtonTapped() {
        guard let passPhrase = passPhraseTextField.text, !passPhrase.isEmpty else { return }
        activityIndicator.animate()
        near.signInUser(passPhrase: passPhrase) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.success == true {
                        self.showHomeController()
                        self.activityIndicator.removeFromSuperview()
                        UserDefaults.standard.set(response.accountName, forKey: Constants.nearAccountName.rawValue)
                        UserDefaults.standard.set(response.privateKey, forKey: Constants.nearPrivateKey.rawValue)
                        UserDefaults.standard.set(response.publicKey, forKey: Constants.nearPublicKey.rawValue)
                    } else if response.success == false {
                        self.activityIndicator.removeFromSuperview()
                        self.showAlert(title: "Error", message: "Account does not exist. Please check your PassPhrase and try again !", actionTitle: "Ok")
                    }
                case .failure(let error):
                    self.activityIndicator.removeFromSuperview()
                    self.showAlert(title: "Error", message: error.localizedDescription, actionTitle: "Ok")
                }
            }
        }
    }
}
