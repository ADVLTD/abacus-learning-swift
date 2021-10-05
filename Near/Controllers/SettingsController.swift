//
//  SettingsController.swift
//  Near
//
//  Created by Bhushan Mahajan on 29/09/21.
//

import UIKit

class SettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Properties/Variables
    
    let near = NearRestAPI()
    var activitiesArray = [AccountActivity]()
    let accountNameContainer = UIView()
    let balanceContainer = UIView()
    
    var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var accountNameLabel: UILabel = {
        let label = UILabel()
        label.text = UserDefaults.standard.string(forKey: Constants.nearAccountName.rawValue)
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    var accountNameLogo: UIImage! = {
        let button = UIImage(systemName: "person.fill")?.withTintColor(.link, renderingMode: .alwaysOriginal)
        return button
    }()
    
    let balanceLabel: UILabel = {
        let label = UILabel()
        label.text = UserDefaults.standard.string(forKey: Constants.nearAcountBalance.rawValue)
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
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
    
    //MARK: - Init Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureSettingsController()
        getAccountActivity()
        getBalance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getBalance()
    }
    
    func getAccountActivity() {
        near.getAccountActivity(accountName: UserDefaults.standard.string(forKey: Constants.nearAccountName.rawValue)!) { activities in
            self.activitiesArray = activities
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - Configuration Functions
    
    func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Settings"
    }
    
    func configureSettingsController() {
        view.backgroundColor = UIColor.grey()
        
        view.addSubview(containerView)
        containerView.anchor(top: view.topAnchor, paddingTop: 150, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, paddingBottom: 40)
        
        containerView.addSubview(accountNameContainer)
        accountNameContainer.anchor(top: containerView.topAnchor, paddingTop: 10, left: containerView.leftAnchor, paddingLeft: 32, right: containerView.rightAnchor, paddingRight: 32, height: 50)
        accountNameContainer.labelContainerView(view: accountNameContainer, image: accountNameLogo, labelField: accountNameLabel)
        
        containerView.addSubview(balanceContainer)
        balanceContainer.anchor(top: accountNameContainer.bottomAnchor, paddingTop: 30, left: containerView.leftAnchor, paddingLeft: 32, right: containerView.rightAnchor, paddingRight: 32, height: 50)
        balanceContainer.labelContainerView(view: balanceContainer, image: balanceLogo, labelField: balanceLabel)
        
        containerView.addSubview(accountActivityLabel)
        accountActivityLabel.anchor(top: balanceContainer.bottomAnchor, paddingTop: 30, left: containerView.leftAnchor, paddingLeft: 32, right: containerView.rightAnchor, paddingRight: 32, height: 45)
        
        containerView.addSubview(tableView)
        tableView.anchor(top: accountActivityLabel.bottomAnchor, paddingTop: 10, left: containerView.leftAnchor, paddingLeft: 5, right: containerView.rightAnchor, paddingRight: 5, bottom: containerView.bottomAnchor, paddingBottom: 5)
        
    }
    
    //MARK: - TableView Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activitiesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AccountActivityCell.identifier, for: indexPath) as! AccountActivityCell
        cell.actionKindLabel.text = "Activity: \(activitiesArray[indexPath.row].action_kind!)"
        cell.hashLabel.text = activitiesArray[indexPath.row].hash
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TransactionStatusController()
        vc.modalPresentationStyle = .fullScreen
        vc.hashString = activitiesArray[indexPath.row].hash
        vc.activity = activitiesArray[indexPath.row].action_kind
        present(vc, animated: true, completion: nil)
    }
    
    func getBalance() {
        if let accountName = UserDefaults.standard.string(forKey: Constants.nearAccountName.rawValue) {
            self.near.getBalance(accountName: accountName) { balance in
                UserDefaults.standard.set(balance, forKey: Constants.nearAcountBalance.rawValue)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}
