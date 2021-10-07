//
//  PassPhraseController.swift
//  Near
//
//  Created by Bhushan Mahajan on 24/09/21.
//

import UIKit

class PassPhraseController: UIViewController {
    
    //MARK: - Properties/Variables
    
    var accountCreationModel: CreateAccountModel?
    
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
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .link
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 10
        return button
    }()
    
    //MARK: - Init Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePassphraseController()
    }
    
    //MARK: - Configuration Functions
    
    func configurePassphraseController() {
        view.backgroundColor = UIColor.grey()
        
        view.addSubview(passphraseTextView)
        passphraseTextView.anchor(width: 300, height: 400)
        passphraseTextView.translatesAutoresizingMaskIntoConstraints = false
        passphraseTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passphraseTextView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        guard let passphrase = accountCreationModel else { return }
        passphraseTextView.text = passphrase.passPhrase
        
        view.addSubview(doneButton)
        doneButton.anchor(top: passphraseTextView.bottomAnchor, paddingTop: 30, width: 100, height: 45)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    //MARK: Selector Functions
    
    @objc func doneButtonTapped() {
        UIPasteboard.general.string = passphraseTextView.text
        dismiss(animated: true, completion: nil)
    }
}
