import UIKit

class CreateLinkDropController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: Properties/Variables
    
    //Variable for storing object of type generate link drop
    var linkDropArray = [GenerateLinkDrop]()
    let accountName = UserDefaults.standard.value(forKey: Constants.nearAccountName.rawValue)
    
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
    let generateLinkDropButton: LoadingButton = {
        let button = LoadingButton(type: .system)
        button.setTitle("Generate", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(generateLinkDropButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = .link
        button.layer.cornerRadius = 10
        return button
    }()
    var linkDropLabel: UILabel = {
        let label = UILabel()
        label.text = "Active LinkDrops"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.isHidden = true
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
        self.hideKeyboardWhenTappedAround()
        configureCreateLinkDropController()
        
        if let linkDropData = UserDefaults.standard.data(forKey: "\(self.accountName!).linkDropArray") {
            //Decoding the JSON data and converting to GenerateLinkDrop object
            let linkDropArray = try! JSONDecoder().decode([GenerateLinkDrop].self, from: linkDropData)
            //Hide the Active Linkdrop label when count is zero.
            if linkDropArray.count > 0 {
                self.linkDropArray.append(contentsOf: linkDropArray)
            }
        }
    }
    
    //MARK: Configuration Functions
    
    //Function for configuration of view
    func configureCreateLinkDropController() {
        //Background color for view.
        view.backgroundColor = UIColor.grey()
        //Configuration of navigation bar
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
        linkDropLabel.anchor(top: generateLinkDropButton.bottomAnchor, paddingTop: 30, left: view.leftAnchor, paddingLeft: 10, right: view.rightAnchor, paddingRight: 10, height: 45)
        
        //Constraints for table view
        view.addSubview(tableView)
        tableView.anchor(top: linkDropLabel.bottomAnchor, paddingTop: 15, left: view.leftAnchor, paddingLeft: 32, right: view.rightAnchor, paddingRight: 32, bottom: view.bottomAnchor, paddingBottom: 50)
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
        guard var amount = amountTextField.text, !amount.isEmpty else {
            showToast(message: "Please Check the amount and try again!")
            return
        }
        //Checking if the value is greater than 1 Near
        if amount > "1" {
            
            generateLinkDropButton.startAnimation()
            
            //Using the generate link drop function from NearRestAPI file
            GenerateLinkDropAPIs.shared.generateLinkDrop(accountName: accountName, amount: amount, privateKey: privateKey) { success in
                
                //Using main thread.
                DispatchQueue.main.async {
                    switch success {
                        //if the completion is successfull
                    case .success(let response):
                        //if the secretkey is nil
                        if response.newKeyPair?.secretKey == nil {
                            self.generateLinkDropButton.stopAnimation()
                            
                            self.showToast(message: "Something went wrong. Try again!")
                        } else {
                            //if the secretkey is not nil
                            self.linkDropLabel.isHidden = false
                            //self.loadingAnimation.isHidden = true
                            //Storing the response in an array.
                            self.linkDropArray.append(response)
                            //Storing the array in UserDefaults for maintaining it throught the session.
                            do {
                                //Converting the objects in array into JSON format to store it in userdefaults.
                                let linkDropData = try? JSONEncoder().encode(self.linkDropArray)
                                //Userdefaults storage
                                UserDefaults.standard.set(linkDropData, forKey: "\(self.accountName!).linkDropArray")
                            } catch {
                                print("Error")
                            }
                            //Clearing the textffield
                            self.amountTextField.text = nil
                            //Reloading the table to show the data.
                            self.tableView.reloadData()
                            
                            self.generateLinkDropButton.stopAnimation()
                        }
                        //if the completion is failure
                    case .failure(let error):
                        self.generateLinkDropButton.stopAnimation()
                        self.showToast(message: error.localizedDescription)
                    }
                }
            }
        } else {
            self.generateLinkDropButton.stopAnimation()
            //If the value is less than 1 Near
            showToast(message: "The amount Should be greater than 1 Near.")
        }
    }
    
    //MARK: TableView Functions
    
    //Function for determining number of rows in the tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //Storing the data from userdefaaults into a variable and checking for nil value.
        
        if let linkDropData = UserDefaults.standard.data(forKey: "\(self.accountName!).linkDropArray") {
            
            //Decoding the JSON data and converting to GenerateLinkDrop object
            let linkDropArray = try! JSONDecoder().decode([GenerateLinkDrop].self, from: linkDropData)
            
            //Hide the Active Linkdrop label when count is zero.
            if linkDropArray.count > 0 {
                linkDropLabel.isHidden = false
            } else {
                linkDropLabel.isHidden = true
            }
            
            //Returning the couunt of the objects from the array
            return linkDropArray.count
        }
        return 0
    }
    
    //Function for determining perticular cell in the tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LinkDropCell.identifier, for: indexPath) as! LinkDropCell
        
        //Storing the data from userdefaaults into a variable and checking for nil value.
        if let linkDropData = UserDefaults.standard.data(forKey: "\(self.accountName!).linkDropArray") {
            do {
                
                //Decoding the JSON data and converting to GenerateLinkDrop object
                if let linkDropArray = try? JSONDecoder().decode([GenerateLinkDrop].self, from: linkDropData) {
                    
                    //Checking for nil value for amount and timestamp.
                    guard let amount = linkDropArray[indexPath.row].newKeyPair?.amount,
                          let timeStamp = linkDropArray[indexPath.row].newKeyPair?.ts else { return cell }
                    
                    //Setting the amount value to the amountLabel
                    cell.ammountLabel.text = "Amount: \(amount) NEAR"
                    
                    //Setting the time value to the timeStampLabel
                    cell.assignDateAndTime(timeStamp: timeStamp)
                }
            } catch {
                print("Error Decoding!!")
            }
        }
        return cell
    }
    
    //Function for height for cell in the tableview
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    //Function for action on selecting any row in the tableview
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Using the alert to creating actionsheet
        let alert = UIAlertController(title: "Choose one option", message: nil, preferredStyle: .actionSheet)
        //Creating the copy link button in actionsheet
        alert.addAction(UIAlertAction(title: "Copy Link", style: .default, handler: { actionSheet in
            //Storing the data from userdefaaults into a variable and checking for nil value.
            if let linkDropData = UserDefaults.standard.data(forKey: "\(self.accountName!).linkDropArray") {
                do {
                    //Decoding the JSON data and converting to GenerateLinkDrop object
                    if let linkDropArray = try? JSONDecoder().decode([GenerateLinkDrop].self, from: linkDropData) {
                        //Checking for nil value in secretkey.
                        guard let secretKey = linkDropArray[indexPath.row].newKeyPair?.secretKey else { return }
                        //URL for claiming link drop,
                        let url = "https://wallet.testnet.near.org/create/testnet/\(secretKey)"
                        //Copying the URl to paste board.
                        UIPasteboard.general.string = url
                    }
                } catch {
                    print("Error Decoding!!")
                }
            }
        }))
        
        //Creating the reclaim near button in actionsheet
        alert.addAction(UIAlertAction(title: "Reclaim Near", style: .default, handler: { actionSheet in
            //Checking for nil value in accountname and secrekey.
            guard let accountName = UserDefaults.standard.string(forKey: Constants.nearAccountName.rawValue) else { return }
            //Storing the data from userdefaaults into a variable and checking for nil value.
            if let linkDropData = UserDefaults.standard.data(forKey: "\(self.accountName!).linkDropArray") {
                do {
                    //Decoding the JSON data and converting to GenerateLinkDrop object
                    if var linkDropArray = try? JSONDecoder().decode([GenerateLinkDrop].self, from: linkDropData) {
                        //Checking for nil value in secretkey.
                        guard let secretKey = linkDropArray[indexPath.row].newKeyPair?.secretKey else { return }
                        //Using the get reclaim near function from NearRestAPI file
                        GenerateLinkDropAPIs.shared.reclaimNear(accountName: accountName, secretKey: secretKey) { success in
                            //Using main thread
                            DispatchQueue.main.async {
                                if success {
                                    //Show the toast message.
                                    self.showToast(message: "Near tokens reclaimed!")
                                    //Remove the object from the array.
                                    linkDropArray.remove(at: indexPath.row)
                                    self.linkDropArray.remove(at: indexPath.row)
                                    do {
                                        //Storing the data from userdefaaults into a variable and checking for nil value.
                                        let linkDropData = try? JSONEncoder().encode(linkDropArray)
                                        UserDefaults.standard.set(linkDropData, forKey: "\(self.accountName!).linkDropArray")
                                    } catch {
                                        print("Error")
                                    }
                                    //Delete rows from the table.
                                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                                    //Reload table.
                                    self.tableView.reloadData()
                                } else {
                                    //Show toast message.
                                    self.showToast(message: "Error reclaiming Near tokens. Try Again!")
                                }
                            }
                        }
                    }
                } catch {
                    print("Error Decoding!!")
                }
            }
        }))
        //Creating the cancel button in actionSheet.
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        //Present the actionsheet.
        present(alert, animated: true, completion: nil)
    }
}
