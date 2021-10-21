import UIKit

class CreateAccountController: UIViewController {
    
    //MARK: - Properties
    
    //All the elements used in Create Account page are configured using anonymous closure pattern
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
    let createAccountButton: LoadingButton = {
        let button = LoadingButton(type: .system)
        button.backgroundColor = .link
        button.setTitle("Create Account", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(createAccountButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
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
        self.hideKeyboardWhenTappedAround()
        configureLoginController()
    }
    
    //MARK: - Configuration Functions
    
    func configureLoginController() {
        //Navigation bar configuration
        navigationItem.title = "Create Account"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .bold)]
        
        //Background color for the page
        view.backgroundColor = UIColor.grey()
       
        //constraints for the Near logo
        view.addSubview(nearLogo)
        nearLogo.anchor(top: view.topAnchor, paddingTop: 80, width: 250, height: 250)
        nearLogo.translatesAutoresizingMaskIntoConstraints = false
        nearLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        //constraints for the Accout name Textfield
        view.addSubview(accountNameContainer)
        accountNameContainer.anchor(left: view.leftAnchor, paddingLeft: 32, right: view.rightAnchor, paddingRight: 32, height: 45)
        accountNameContainer.translatesAutoresizingMaskIntoConstraints = false
        accountNameContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        accountNameContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        accountNameContainer.textContainerView(view: accountNameContainer, image: accountNameLogo, textField: accountNameTextField)
        
        //constraints for the Create Account button
        view.addSubview(createAccountButton)
        createAccountButton.anchor(top: accountNameContainer.bottomAnchor, paddingTop: 35, width: 200, height: 45)
        createAccountButton.translatesAutoresizingMaskIntoConstraints = false
        createAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        //constraints for the sign in button
        view.addSubview(signInButton)
        signInButton.anchor(bottom: view.bottomAnchor, paddingBottom: 50, width: 280, height: 35)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    //MARK: - Helper Functions
    
    //Function used to navigate to the screen where the pass pharse for the account is displayed.
    func showPassphraseController(response: CreateAccountModel) {
        let vc = PassPhraseController()
        vc.accountCreationModel = response
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    //Function used to show alert message.
    func showAlert(title: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Selector Functions
    
    @objc func createAccountButtonTapped() {
        //Checking the account name is not nil and the textfield is not empty
        guard let username = accountNameTextField.text?.replacingOccurrences(of: " ", with: ""), !username.isEmpty else { return }
        
        //Loading animation initiated
        createAccountButton.startAnimation()
        
        //Create user function called from NearRestApi file.
        CreateAccountAPI.shared.createUser(username: username) { result in
            
            //using the main thread for executing the closure as it contains UI elements.
            DispatchQueue.main.async {
                switch result {
                    
                //if the result from server is success.
                case .success(let response):
                    
                    //loading animation removed
                    self.createAccountButton.stopAnimation()
                    
                    //checking if passphrase is not empty/nil
                    if response.passPhrase != nil {
                        
                        //navigate to passphrase screen to show pass phrase
                        self.showPassphraseController(response: response)
                        
                    //checking if statusCode is not nil, if it is not nil then an error has occured
                    } else if response.statusCode != nil {
                        
                        //loading animation removed
                        self.createAccountButton.stopAnimation()
                        
                        //showing alert message for error
                        self.showAlert(title: "Error", message: "Account Name already exists please try again with different account name!", actionTitle: "ok")
                    }
                    
                //if the result from server is failure
                case .failure(let error):
                    //loading animation removed
                    self.createAccountButton.stopAnimation()
                    
                    //showing alert message for error
                    self.showAlert(title: "Error", message: error.localizedDescription, actionTitle: "ok")
                }
            }
        }
    }
    
    @objc func signInButtonTapped() {
        //Navigation to sign in page on button pressed
        let signInController = SignInController()
        navigationController?.pushViewController(signInController, animated: true)
    }
}

