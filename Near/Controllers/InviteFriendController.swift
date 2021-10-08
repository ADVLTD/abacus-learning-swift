//
//  InviteFriendController.swift
//  Near
//
//  Created by Bhushan Mahajan on 06/10/21.
//

import UIKit

class InviteFriendController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: Properties/Variables
    
    //Variable for storing object of type generate link drop
    var linkDropArray: [GenerateLinkDrop] = []
    
    //All the elements used in settings page are configured using anonymous closure pattern
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
    var linkDropLabel: UILabel = {
        let label = UILabel()
        label.text = "LinkDrops"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.grey()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(LinkDropCell.self, forCellReuseIdentifier: LinkDropCell.identifier)
        return tableView
    }()
    
    //MARK: Init Fucntions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureController()
    }
    
    //MARK: Selector Functions
    
    //Action for generate link drop button
    @objc func generateLinkDropButtonTapped() {
        //Checking for nil value in accountname, privatekey.
        guard let accountName = UserDefaults.standard.string(forKey: Constants.nearAccountName.rawValue),
              let privateKey = UserDefaults.standard.string(forKey: Constants.nearPrivateKey.rawValue) else {
                  return
              }
        //Checking for nil value in amount.
        guard let amount = amountTextField.text, !amount.isEmpty else {
            showToast(message: "Please Check the amount and try again!")
            return
        }
        //Checking if the value is greater than 1 Near
        if amount > "1" {
            //Using the generate link drop function from NearRestAPI file
            NearRestAPI.shared.generateLinkDrop(accountName: accountName, amount: amount, privateKey: privateKey) { success in
                //Using main thread.
                DispatchQueue.main.async {
                    switch success {
                    //if the completion is successfull
                    case .success(let response):
                        //if the secretkey is nil
                        if response.secretKey == nil {
                            self.showToast(message: "Something went wrong.")
                        //if the secretkey is not nil
                        } else {
                            self.linkDropLabel.isHidden = false
                            self.linkDropArray.append(response)
                            self.linkDropArray.count
                            self.amountTextField.text = nil
                            self.tableView.reloadData()
                        }
                    //if the completion is failure
                    case .failure(let error):
                        self.showToast(message: error.localizedDescription)
                    }
                }
            }
        //If the value is less than 1 Near
        } else {
            showToast(message: "The amount Should be greater than 1 Near.")
        }
    }
    
    //MARK: Configuration Functions
    
    //Function for configuration of view
    func configureController() {
        //Background color for view.
        view.backgroundColor = UIColor.grey()
        //Configuration of navigation bar
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Link Drop"
        //Constraints for amount textfield
        view.addSubview(amountContainer)
        amountContainer.anchor(top: view.topAnchor, paddingTop: 150, left: view.leftAnchor, paddingLeft: 32, right: view.rightAnchor, paddingRight: 32, height: 45)
        amountContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        amountContainer.textContainerView(view: amountContainer, image: amountLogo, textField: amountTextField)
        //Constraints for generate link drop button
        view.addSubview(generateLinkDropButton)
        generateLinkDropButton.anchor(top: amountContainer.bottomAnchor, paddingTop: 30, width: 200, height: 45)
        generateLinkDropButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //Constraints for link drop label
        view.addSubview(linkDropLabel)
        linkDropLabel.isHidden = true
        linkDropLabel.anchor(top: generateLinkDropButton.bottomAnchor, paddingTop: 30, left: view.leftAnchor, paddingLeft: 10, right: view.rightAnchor, paddingRight: 10, height: 45)
        //Constraints for table view
        view.addSubview(tableView)
        tableView.anchor(top: linkDropLabel.bottomAnchor, paddingTop: 30, left: view.leftAnchor, paddingLeft: 32, right: view.rightAnchor, paddingRight: 32, bottom: view.bottomAnchor, paddingBottom: 50)
    }
    
    //MARK: TableView Functions
    
    //Function for determining number of rows in the tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return linkDropArray.count
    }
    
    //Function for determining perticular cell in the tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LinkDropCell.identifier, for: indexPath) as! LinkDropCell
        cell.ammountLabel.text = "Amount: \(linkDropArray[indexPath.row].amount!)"
        return cell
    }
    
    //Function for height for cell in the tableview
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    //Function for action on selecting any row in the tableview
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Using the alert to creating actionsheet
        let alert = UIAlertController(title: "Choose one option", message: nil, preferredStyle: .actionSheet)
        //Creating the copy link button in actionsheet
        alert.addAction(UIAlertAction(title: "Copy Link", style: .default, handler: { actionSheet in
            //Checking for nil value in secretkey
            guard let secretKey = self.linkDropArray[indexPath.row].secretKey else {
                return
            }
            //URL for claiming link drop,
            let url = "https://wallet.testnet.near.org/create/testnet/\(secretKey)"
            //Copying the URl to paste board.
            UIPasteboard.general.string = url
        }))
        //Creating the reclaim near button in actionsheet
        alert.addAction(UIAlertAction(title: "Reclaim Near", style: .default, handler: { actionSheet in
            //Checking for nil value in accountname and secrekey.
            guard let accountName = UserDefaults.standard.string(forKey: Constants.nearAccountName.rawValue),
                  let secretKey = self.linkDropArray[indexPath.row].secretKey else {
                      return
                  }
            //Using the get reclaim near function from NearRestAPI file
            NearRestAPI.shared.reclaimNear(accountName: accountName, secretKey: secretKey) { success in
                //Using main thread
                DispatchQueue.main.async {
                    if success {
                        self.showToast(message: "Near tokens reclaimed!")
                        self.linkDropArray.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                        self.tableView.reloadData()
                        if self.linkDropArray.count == 0 {
                            self.linkDropLabel.isHidden = true
                        }
                    } else {
                        self.showToast(message: "Error reclaiming Near tokens. Try Again!")
                    }
                }
            }
        }))
        present(alert, animated: true, completion: nil)
    }
}
