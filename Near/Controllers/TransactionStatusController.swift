//
//  PopupView.swift
//  Near
//
//  Created by Bhushan Mahajan on 30/09/21.
//

import UIKit

class TransactionStatusController: UIViewController {
    
    //MARK: - Properties
    
    var hashString: String?
    var activity: String?
    let near = NearRestAPI()
    
    let activityContainer = UIView()
    let statusContainer = UIView()
    
    let statusLogo: UIImage! = {
        let button = UIImage(systemName: "exclamationmark.icloud")?.withTintColor(.link, renderingMode: .alwaysOriginal)
        return button
    }()
    
    let activityLogo: UIImage! = {
        let button = UIImage(systemName: "doc.text.fill")?.withTintColor(.link, renderingMode: .alwaysOriginal)
        return button
    }()
    
    let activityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    let viewActivityButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("View Activity", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(viewActivityButtonTapped), for: .touchUpInside)
        button.backgroundColor = .link
        button.layer.cornerRadius = 10
        return button
    }()
    
    let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        button.backgroundColor = .link
        button.layer.cornerRadius = 10
        return button
    }()
    
    //MARK: - Init Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePopUpWindow()
        transactionDetails()
    }
    
    //MARK: - Selector Functions
    
    @objc func doneButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func viewActivityButtonTapped() {
        let url = "\(Constants.viewActivityURL.rawValue)\(hashString!)"
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
    
    //MARK: - Configuration Functions
    
    func configurePopUpWindow() {
        view.backgroundColor = UIColor.grey()
        
        view.addSubview(activityContainer)
        activityContainer.anchor(top: view.topAnchor, paddingTop: 150, left: view.leftAnchor, paddingLeft: 32, right: view.rightAnchor, paddingRight: 32, height: 45)
        activityContainer.labelContainerView(view: activityContainer, image: activityLogo, labelField: activityLabel)
        
        view.addSubview(statusContainer)
        statusContainer.anchor(top: activityContainer.bottomAnchor, paddingTop: 30, left: view.leftAnchor, paddingLeft: 32, right: view.rightAnchor, paddingRight: 32, height: 45)
        statusContainer.labelContainerView(view: statusContainer, image: statusLogo, labelField: statusLabel)
        
        view.addSubview(viewActivityButton)
        viewActivityButton.anchor(top: statusContainer.bottomAnchor, paddingTop: 30, width: 200, height: 45)
        viewActivityButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(doneButton)
        doneButton.anchor(top: viewActivityButton.bottomAnchor, paddingTop: 30, width: 200, height: 45)
        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    //MARK: Helper Functions
    
    func transactionDetails() {
        guard let accountName = UserDefaults.standard.string(forKey: Constants.nearAccountName.rawValue) else { return }
        activityLabel.text = "Activity: \(activity!)"
        near.transactionStatus(accountName: accountName, hash: hashString!) { success in
            DispatchQueue.main.async {
                if success {
                    self.statusLabel.text = "Status: Successfull"
                } else {
                    self.statusLabel.text = "Status: Failure"
                }
            }
        }
    }

}
