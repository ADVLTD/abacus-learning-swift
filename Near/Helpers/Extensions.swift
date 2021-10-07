//
//  Extensions.swift
//  Near
//
//  Created by Bhushan Mahajan on 24/09/21.
//

import UIKit

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat? = 0, left: NSLayoutXAxisAnchor? = nil, paddingLeft: CGFloat? = 0, right: NSLayoutXAxisAnchor? = nil, paddingRight: CGFloat? = 0, bottom: NSLayoutYAxisAnchor? = nil, paddingBottom: CGFloat? = 0, width: CGFloat? = nil, height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop!).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft!).isActive = true
        }
        if let right = right {
            if let paddingRight = paddingRight{
                rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
            }
        }
        if let bottom = bottom {
            if let paddingBottom = paddingBottom {
                bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
            }
        }
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func textContainerView(view: UIView, image: UIImage, textField: UITextField) {
        view.backgroundColor = .clear
        let imageView = UIImageView()
        imageView.image = image
        imageView.alpha = 1
        view.addSubview(imageView)
        imageView.anchor(left: view.leftAnchor, paddingLeft: 8, width: 30, height: 30)
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(textField)
        textField.anchor(left: imageView.rightAnchor, paddingLeft: 30, right: view.rightAnchor, paddingRight: 8)
        textField.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor.link.withAlphaComponent(1)
        view.addSubview(separatorView)
        separatorView.anchor(left: view.leftAnchor, paddingLeft: 8, right: view.rightAnchor, paddingRight: 0, bottom: view.bottomAnchor, paddingBottom: 0, height: 1)
    }
    
    func labelContainerView(view: UIView, image: UIImage, labelField: UILabel) {
        view.backgroundColor = .clear
        let imageView = UIImageView()
        imageView.image = image
        imageView.alpha = 1
        view.addSubview(imageView)
        imageView.anchor(left: view.leftAnchor, paddingLeft: 8, width: 30, height: 30)
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(labelField)
        labelField.anchor(left: imageView.rightAnchor, paddingLeft: 20, right: view.rightAnchor, paddingRight: 8)
        labelField.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor.link.withAlphaComponent(1)
        view.addSubview(separatorView)
        separatorView.anchor(left: view.leftAnchor, paddingLeft: 8, right: view.rightAnchor, paddingRight: 0, bottom: view.bottomAnchor, paddingBottom: 0, height: 1)
    }
}

extension UITextField {
    
    func StyleTextField(placeholder: String, isSecureText: Bool) {
        self.borderStyle = .none
        self.font = UIFont.systemFont(ofSize: 19)
        self.textColor = .white
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.isSecureTextEntry = isSecureText
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
}

extension UIColor {
    static func grey() -> UIColor {
        return UIColor(red: 31/255, green: 32/255, blue: 34/255, alpha: 1)
    }
}

extension UIViewController {
    
    func showToast(message : String) {
        guard let window = UIApplication.shared.keyWindow else { return }
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.textAlignment = .center
        toastLabel.backgroundColor = UIColor.grey()
        toastLabel.textColor = .white
        toastLabel.font = .systemFont(ofSize: 18)
        toastLabel.numberOfLines = 0
        toastLabel.layer.cornerRadius = 10
        toastLabel.layer.masksToBounds = true
        toastLabel.clipsToBounds  =  true
        
        let textSize = toastLabel.intrinsicContentSize
        let labelWidth = min(textSize.width, window.frame.width - 40)
        let labelHeight = (textSize.width / window.frame.width) * 30
        let adjustedHeight = max(labelHeight, textSize.height + 20)
        
        toastLabel.frame = CGRect(x: 20, y: (window.frame.height - 90) - adjustedHeight, width: labelWidth + 20, height: adjustedHeight)
        toastLabel.center.x = window.center.x
        window.addSubview(toastLabel)
        
        UIView.animate(withDuration: 10) {
            toastLabel.alpha = 0
        } completion: { _ in
            toastLabel.removeFromSuperview()
        }
    }
}
