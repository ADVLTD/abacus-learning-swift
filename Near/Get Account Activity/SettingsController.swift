//
//  SettingsController.swift
//  Near
//
//  Created by Bhushan Mahajan on 29/09/21.
//

import UIKit

class SettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Properties/Variables
    
    //Array to store objects of AccountActivity recieved from server
    var activitiesArray = [AccountActivity]()
    
    //All the elements used in settings page are configured using anonymous closure pattern
    let accountNameContainer = UIView()
    let balanceContainer = UIView()
    var containerView: UIView = {
        let view = UIView()
        return view
    }()
    var accountNameLabel: UILabel = {
        let label = UILabel()
        label.text = UserDefaults.standard.string(forKey: Constants.nearAccountName.rawValue)
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    var accountNameLogo: UIImage! = {
        let button = UIImage(systemName: "person.fill")?.withTintColor(.link, renderingMode: .alwaysOriginal)
        return button
    }()
    let balanceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    var balanceLogo: UIImage! = {
        let button = UIImage(systemName: "dollarsign.circle")?.withTintColor(.link, renderingMode: .alwaysOriginal)
        return button
    }()
    var accountActivityLabel: UILabel = {
        let label = UILabel()
        label.text = "Account Activity:"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        return label
    }()
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.grey()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AccountActivityCell.self, forCellReuseIdentifier: AccountActivityCell.identifier)
        return tableView
    }()
    let inviteFriendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Invite Friend", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(inviteFriendButtonTapped), for: .touchUpInside)
        button.backgroundColor = .link
        button.layer.cornerRadius = 10
        return button
    }()
    
    //MARK: - Init Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAccountActivity()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureNavigationBar()
        configureSettingsController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getBalance()
    }
    
    //MARK: Selector Functions
    
    //Action for invite button
    @objc func inviteFriendButtonTapped() {
        
        //Navigate to InviteFriend controller view
        let vc = CreateLinkDropController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Configuration Functions
    
    //Function to configure navigation bar
    func configureNavigationBar() {
        navigationItem.title = "Settings"
    }
    
    //Function to configure view
    func configureSettingsController() {
        //Background color for view
        view.backgroundColor = UIColor.grey()
        
        //Constraints for the container view that contains all the elements.
        view.addSubview(containerView)
        containerView.anchor(top: view.topAnchor, paddingTop: 150, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, paddingBottom: 40)
        
        //Constraints for accountname label.
        containerView.addSubview(accountNameContainer)
        accountNameContainer.anchor(top: containerView.topAnchor, paddingTop: 10, left: containerView.leftAnchor, paddingLeft: 32, right: containerView.rightAnchor, paddingRight: 32, height: 50)
        accountNameContainer.labelContainerView(view: accountNameContainer, image: accountNameLogo, labelField: accountNameLabel)
        
        //Constraints for balance label.
        containerView.addSubview(balanceContainer)
        balanceContainer.anchor(top: accountNameContainer.bottomAnchor, paddingTop: 30, left: containerView.leftAnchor, paddingLeft: 32, right: containerView.rightAnchor, paddingRight: 32, height: 50)
        balanceContainer.labelContainerView(view: balanceContainer, image: balanceLogo, labelField: balanceLabel)
        
        //Constraints for Invite friend button.
        containerView.addSubview(inviteFriendButton)
        inviteFriendButton.anchor(top: balanceContainer.bottomAnchor, paddingTop: 30, width: 250, height: 45)
        inviteFriendButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        //Constraints for account activity label.
        containerView.addSubview(accountActivityLabel)
        accountActivityLabel.anchor(top: inviteFriendButton.bottomAnchor, paddingTop: 30, left: containerView.leftAnchor, paddingLeft: 32, right: containerView.rightAnchor, paddingRight: 32, height: 45)
        
        //Constraints for the tableview that account activity shows.
        containerView.addSubview(tableView)
        tableView.anchor(top: accountActivityLabel.bottomAnchor, paddingTop: 10, left: containerView.leftAnchor, paddingLeft: 5, right: containerView.rightAnchor, paddingRight: 5, bottom: containerView.bottomAnchor, paddingBottom: 5)
    }
    
    //MARK: - Helper Functions
    
    //Function to get account activity from the server.
    func getAccountActivity() {
        
        //Checking that accountname is not nil.
        guard let accountName = UserDefaults.standard.string(forKey: Constants.nearAccountName.rawValue) else {
            showToast(message: "Account Name not found")
            return
        }
        
        //Using the get account activity from NearRestAPI file
        AccountActivityAPIs.shared.getAccountActivity(accountName: accountName) { activities in
            
            //Assigning the activities array to the array declared above.
            self.activitiesArray = activities
            
            //Using the main thread for UI operation
            DispatchQueue.main.async {
                
                //Reloading the tableview
                self.tableView.reloadData()
            }
        }
    }
    
    //Function to get account balance from the server.
    func getBalance() {
        
        //Checking that accountname is not nil.
        if let accountName = UserDefaults.standard.string(forKey: Constants.nearAccountName.rawValue) {
            
            //Using the get account balance from NearRestAPI file
            AccountActivityAPIs.shared.getBalance(accountName: accountName) { balance in
                
                //Using the main thread for UI operation
                DispatchQueue.main.async {
                   
                    //Assigning the balance to balance label
                    self.balanceLabel.text = "\(balance)  NEAR"
                   
                    //Reloading the tableview
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //MARK: - TableView Functions
    
    //Function for determining number of rows in the tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activitiesArray.count
    }
    
    //Function for determining perticular cell in the tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AccountActivityCell.identifier, for: indexPath) as! AccountActivityCell
        let accountName = UserDefaults.standard.string(forKey: Constants.nearAccountName.rawValue)
        let tableNumber = activitiesArray[indexPath.row]
        
        //Formatting the activity kind to more readable format.
        if tableNumber.action_kind! == "TRANSFER" && tableNumber.receiver_id! == accountName {
            cell.actionKindLabel.text = "Activity: Recieved Near"
        } else if tableNumber.action_kind! == "TRANSFER" && tableNumber.signer_id! == accountName {
            cell.actionKindLabel.text = "Activity: Sent Near"
        } else if tableNumber.action_kind! == "FUNCTION_CALL" {
            cell.actionKindLabel.text = "Activity: Method called"
        } else if tableNumber.action_kind! == "ADD_KEY" {
            cell.actionKindLabel.text = "Activity: Access key added"
        } else if tableNumber.action_kind! == "CREATE_ACCOUNT" {
            cell.actionKindLabel.text = "Activity: New account created"
        }
        return cell
    }
    
    //Function for height for cell in the tableview
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    //Function for action on selecting any row in the tableview
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TransactionStatusController()
        let accountName = UserDefaults.standard.string(forKey: Constants.nearAccountName.rawValue)
        let tableNumber = activitiesArray[indexPath.row]
       
        //Formatting the activity kind to more readable format.
        if tableNumber.action_kind! == "TRANSFER" && tableNumber.receiver_id! == accountName {
            vc.activity = "Recieved Near"
        } else if tableNumber.action_kind! == "TRANSFER" && tableNumber.signer_id! == accountName {
            vc.activity = "Sent Near"
        } else if tableNumber.action_kind! == "FUNCTION_CALL" {
            vc.activity = "Method called"
        } else if tableNumber.action_kind! == "ADD_KEY" {
            vc.activity = "Access key added"
        } else if tableNumber.action_kind! == "CREATE_ACCOUNT" {
            vc.activity = "New account created"
        }
        
        vc.hashString = activitiesArray[indexPath.row].hash
        vc.gasFees = activitiesArray[indexPath.row].args?.gas
        present(vc, animated: true, completion: nil)
    }
}
