//
//  PopupView.swift
//  Near
//
//  Created by Bhushan Mahajan on 30/09/21.
//

import UIKit

class TransactionStatusController: UIViewController {
    
    //MARK: - Properties
    
    //Variables used for passing data from settings controller.
    var hashString: String?
    var activity: String?
    
    //All the elements used in settings page are configured using anonymous closure pattern
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
        label.textColor = .white
        return label
    }()
    let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
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
    
    //Action for done button
    @objc func doneButtonTapped() {
        //Remove the transaction view
        dismiss(animated: true, completion: nil)
    }
    
    //Action for view activity button
    @objc func viewActivityButtonTapped() {
        //Checking for nil value in hashString.
        guard let hashString = hashString else {
            showToast(message: "Hash String not found.")
            return
        }
        //URL for going to activity page on browser.
        let url = "\(Constants.viewActivityURL.rawValue)\(hashString)"
        if let url = URL(string: url) {
            //Opening the URL in browser.
            UIApplication.shared.open(url)
        }
    }
    
    //MARK: - Configuration Functions
    
    //Function for configuration of view.
    func configurePopUpWindow() {
        
        //Background color for view
        view.backgroundColor = UIColor.grey()
        
        //Constraints for activity label
        view.addSubview(activityContainer)
        activityContainer.anchor(top: view.topAnchor, paddingTop: 150, left: view.leftAnchor, paddingLeft: 32, right: view.rightAnchor, paddingRight: 32, height: 45)
        activityContainer.labelContainerView(view: activityContainer, image: activityLogo, labelField: activityLabel)
        
        //Constraints for status label
        view.addSubview(statusContainer)
        statusContainer.anchor(top: activityContainer.bottomAnchor, paddingTop: 30, left: view.leftAnchor, paddingLeft: 32, right: view.rightAnchor, paddingRight: 32, height: 45)
        statusContainer.labelContainerView(view: statusContainer, image: statusLogo, labelField: statusLabel)
        
        //Constraints for activity button
        view.addSubview(viewActivityButton)
        viewActivityButton.anchor(top: statusContainer.bottomAnchor, paddingTop: 30, width: 200, height: 45)
        viewActivityButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
       
        //Constraints for done button
        view.addSubview(doneButton)
        doneButton.anchor(top: viewActivityButton.bottomAnchor, paddingTop: 30, width: 200, height: 45)
        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    //MARK: Helper Functions
    
    //Function for getting the transaction details.
    func transactionDetails() {
        
        //Checking that accountname, activity and hashstring is not nil.
        guard let accountName = UserDefaults.standard.string(forKey: Constants.nearAccountName.rawValue),
              let activity = activity,
              let hashString = hashString else {
            showToast(message: "Account Name not found.")
            return
        }
        
        //Assigning text to activity label.
        activityLabel.text = "Activity: \(activity)"
        
        //Using the transaction status function from NearRestAPI file
        NearRestAPI.shared.transactionStatus(accountName: accountName, hash: hashString) { success in
            
            //Using main thread for UI elements
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
