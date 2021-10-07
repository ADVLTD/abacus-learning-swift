//
//  ViewController.swift
//  Near
//
//  Created by Bhushan Mahajan on 24/09/21.
//

import UIKit

class CreateAccountController: UIViewController {
    
    //MARK: - Properties
    
    let near = NearRestAPI()
    let activityIndicator = ActivityIndicator()
    let accountNameContainer = UIView()
    
    let accountNameTextField: UITextField = {
        let tf = UITextField()
        tf.StyleTextField(placeholder: "Enter AccountName", isSecureText: false)
        return tf
    }()
    
    let accountNameLogo: UIImage! = {
        let button = UIImage(systemName: "person.fill")?.withTintColor(.link, renderingMode: .alwaysOriginal)
        return button
    }()
    let nearLogo: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "nearLogoWhite")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .link
        button.setTitle("Create Account", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(createAccountButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 10
        return button
    }()
    
    let signInButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        attributedTitle.append(NSAttributedString(string:"  Sign In", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.link]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Init Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLoginController()
    }
    
    //MARK: - Configuration Functions
    
    func configureLoginController() {
        
        navigationItem.title = "Create Account"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        view.backgroundColor = UIColor.grey()
        
        view.addSubview(nearLogo)
        nearLogo.anchor(top: view.topAnchor, paddingTop: 80, width: 250, height: 250)
        nearLogo.translatesAutoresizingMaskIntoConstraints = false
        nearLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(accountNameContainer)
        accountNameContainer.anchor(left: view.leftAnchor, paddingLeft: 32, right: view.rightAnchor, paddingRight: 32, height: 45)
        accountNameContainer.translatesAutoresizingMaskIntoConstraints = false
        accountNameContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        accountNameContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        accountNameContainer.textContainerView(view: accountNameContainer, image: accountNameLogo, textField: accountNameTextField)
        
        view.addSubview(createAccountButton)
        createAccountButton.anchor(top: accountNameContainer.bottomAnchor, paddingTop: 35, width: 200, height: 45)
        createAccountButton.translatesAutoresizingMaskIntoConstraints = false
        createAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(activityIndicator)
        activityIndicator.anchor(top: createAccountButton.bottomAnchor, paddingTop: 30, width: 150, height: 40)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(signInButton)
        signInButton.anchor(bottom: view.bottomAnchor, paddingBottom: 50, width: 280, height: 35)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    //MARK: - Helper Functions
    
    func showPassphraseController(response: CreateAccountModel) {
        let vc = PassPhraseController()
        vc.accountCreationModel = response
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Selector Functions
    
    @objc func createAccountButtonTapped() {
        guard let username = accountNameTextField.text, !username.isEmpty else { return }
        activityIndicator.animate()
        near.createUser(username: username) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.activityIndicator.removeFromSuperview()
                    if response.passPhrase != nil {
                        self.showPassphraseController(response: response)
                    } else if response.statusCode != nil {
                        self.activityIndicator.removeFromSuperview()
                        self.showAlert(title: "Error", message: "Account already exists. Please check your account name and try again !", actionTitle: "ok")
                    }
                case .failure(let error):
                    self.activityIndicator.removeFromSuperview()
                    self.showAlert(title: "Error", message: error.localizedDescription, actionTitle: "ok")
                }
            }
        }
    }
    
    @objc func signInButtonTapped() {
        let signInController = SignInController()
        navigationController?.pushViewController(signInController, animated: true)
    }
}

