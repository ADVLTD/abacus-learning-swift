//
//  InviteFriendController.swift
//  Near
//
//  Created by Bhushan Mahajan on 06/10/21.
//

import UIKit

class InviteFriendController: UIViewController {
    
    //MARK: Properties/Variables
    
    let near = NearRestAPI()
    var secretKey: String?
    let amountContainer = UIView()
    
    let amountTextField: UITextField = {
        let tf = UITextField()
        tf.StyleTextField(placeholder: "Enter Amount", isSecureText: false)
        return tf
    }()
    
    let amountLogo: UIImage! = {
        let button = UIImage(systemName: "paperplane.fill")?.withTintColor(.link, renderingMode: .alwaysOriginal)
        return button
    }()
    
    let generateLinkDropButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Generate", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(generateLinkDropButtonTapped), for: .touchUpInside)
        button.backgroundColor = .link
        button.layer.cornerRadius = 10
        return button
    }()
    
    let containerView = UIView()
    
    let ammountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let copyLinkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Copy Link", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(copyLinkButtonTapped), for: .touchUpInside)
        button.backgroundColor = .link
        button.layer.cornerRadius = 10
        return button
    }()
    
    let reclaimButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reclaim Near", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(reclaimButtonTapped), for: .touchUpInside)
        button.backgroundColor = .link
        button.layer.cornerRadius = 10
        return button
    }()
    
    //MARK: Init Fucntions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureController()
        containerView.isHidden = true
    }
    
    //MARK: Selector Functions
    
    @objc func generateLinkDropButtonTapped() {
        guard let accountName = UserDefaults.standard.string(forKey: Constants.nearAccountName.rawValue),
              let privateKey = UserDefaults.standard.string(forKey: Constants.nearPrivateKey.rawValue) else {
                  return
              }
        guard let amount = amountTextField.text, !amount.isEmpty else {
            showToast(message: "Please Check the amount and try again!")
            return
        }
        if amount > "1" {
            near.generateLinkDrop(accountName: accountName, amount: amount, privateKey: privateKey) { success in
                switch success {
                case .success(let response):
                    self.secretKey = response.secretKey
                    DispatchQueue.main.async {
                        self.containerView.isHidden = false
                        self.ammountLabel.text = "Amount: \(response.amount!) Near"
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            showToast(message: "The amount Should be greater than 1 Near.")
        }
    }
    
    @objc func copyLinkButtonTapped() {
        let url = "https://wallet.testnet.near.org/create/testnet/\(secretKey!)"
        UIPasteboard.general.string = url
    }
    
    @objc func reclaimButtonTapped() {
        guard let accountName = UserDefaults.standard.string(forKey: Constants.nearAccountName.rawValue),
              let secretKey = self.secretKey else {
            return
        }
        near.reclaimNear(accountName: accountName, secretKey: secretKey) { success in
            DispatchQueue.main.async {
                if success {
                    self.showToast(message: "Near tokens reclaimed!")
                    self.containerView.removeFromSuperview()
                } else {
                    self.showToast(message: "Error reclaiming Near tokens. Try Again!")
                }
            }
        }
    }
    
    //MARK: Configuration Functions
    
    func configureController() {
        view.backgroundColor = UIColor.grey()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Link Drop"
        
        view.addSubview(amountContainer)
        amountContainer.anchor(top: view.topAnchor, paddingTop: 150, left: view.leftAnchor, paddingLeft: 32, right: view.rightAnchor, paddingRight: 32, height: 45)
        amountContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        amountContainer.textContainerView(view: amountContainer, image: amountLogo, textField: amountTextField)
        
        view.addSubview(generateLinkDropButton)
        generateLinkDropButton.anchor(top: amountContainer.bottomAnchor, paddingTop: 30, width: 200, height: 45)
        generateLinkDropButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(containerView)
        containerView.anchor(top: generateLinkDropButton.bottomAnchor, paddingTop: 50, left: view.leftAnchor, paddingLeft: 10, right: view.rightAnchor, paddingRight: 10, bottom: view.bottomAnchor, paddingBottom: 50)
        
        containerView.addSubview(ammountLabel)
        ammountLabel.anchor(top: containerView.topAnchor, paddingTop: 20, left: containerView.leftAnchor, paddingLeft: 20, right: containerView.rightAnchor, paddingRight: 20, height: 45)
        
        containerView.addSubview(copyLinkButton)
        copyLinkButton.anchor(top: ammountLabel.bottomAnchor, paddingTop: 20, width: 200, height: 45)
        copyLinkButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        containerView.addSubview(reclaimButton)
        reclaimButton.anchor(top: copyLinkButton.bottomAnchor, paddingTop: 20, width: 200, height: 45)
        reclaimButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
    }
}
