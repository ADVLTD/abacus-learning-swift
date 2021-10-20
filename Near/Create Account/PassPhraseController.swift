import UIKit

class PassPhraseController: UIViewController {
    
    //MARK: - Properties/Variables
    
    //Instance of create account to pass the passphrase to this page.
    var accountCreationModel: CreateAccountModel?
    
    //All the elements used in sign in page are configured using anonymous closure pattern
    let passphraseTextView: UITextView = {
        let tf = UITextView()
        tf.allowsEditingTextAttributes = false
        tf.autocapitalizationType = UITextAutocapitalizationType.none
        tf.textColor = .white
        tf.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        tf.autocorrectionType = UITextAutocorrectionType.no
        tf.backgroundColor = UIColor.grey()
        return tf
    }()
    let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .link
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 10
        return button
    }()
    
    //MARK: - Init Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configurePassphraseController()
    }
    
    //MARK: - Configuration Functions
    
    func configurePassphraseController() {
        
        //Background color for the view
        view.backgroundColor = UIColor.grey()
        
        //constraints for the passphrase textview
        view.addSubview(passphraseTextView)
        passphraseTextView.anchor(width: 300, height: 400)
        passphraseTextView.translatesAutoresizingMaskIntoConstraints = false
        passphraseTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passphraseTextView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        //Checking for nil value in accountcreationModel instance declared.
        guard let passphrase = accountCreationModel else { return }
        
        //Passing the passpharse stored in variable to passphrase textview
        passphraseTextView.text = passphrase.passPhrase
        
        //Constraints for continue button
        view.addSubview(doneButton)
        doneButton.anchor(top: passphraseTextView.bottomAnchor, paddingTop: 30, width: 100, height: 45)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    //MARK: Selector Functions
    
    @objc func doneButtonTapped() {
        
        //Using the pasteBoard to copy the pass phrase for the user to paste it and save it.
        UIPasteboard.general.string = passphraseTextView.text
        
        //Checking for empty text view and saving the passphrase in a variale to paass it to signin function.
        guard let passPhrase = passphraseTextView.text else { return }
        
        //Sign In User function called from NearRestApi file.
        CreateAccountAPI.shared.signInUser(passPhrase: passPhrase) { result in
            
            //using the main thread for executing the closure as it contains ui elements.
            DispatchQueue.main.async {
                switch result {
                
                    //if the reult is success for the completion of the function
                case .success(let response):
                   
                    //if the result from server is success
                    if response.success == true {
                        
                        //navigate to home screen
                        self.showHomeController()
                        
                        //Saving the accountname, privatekey and publickey in userdefaults for later use.
                        UserDefaults.standard.set(response.accountName, forKey: Constants.nearAccountName.rawValue)
                        UserDefaults.standard.set(response.privateKey, forKey: Constants.nearPrivateKey.rawValue)
                        UserDefaults.standard.set(response.publicKey, forKey: Constants.nearPublicKey.rawValue)
                    
                        //if the result from server is false
                    } else if response.success == false {
                        
                        //Show alert message for error message
                        self.showToast(message: "Account does not exist. Please check your PassPhrase and try again !")
                    }
                
                    //if the reult is failure for the completion of the function
                case .failure(let error):
                    
                    //Show alert message for error message
                    self.showToast(message: error.localizedDescription)
                }
            }
        }
    }
    
    //MARK: Helper Functions
    
    //Function to naviagte to Home screen
    func showHomeController() {
        let vc = HomeController()
        navigationController?.setViewControllers([vc], animated: true)
    }
}
