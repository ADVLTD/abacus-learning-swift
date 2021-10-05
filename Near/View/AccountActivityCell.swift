//
//  AccountActivityCell.swift
//  Near
//
//  Created by Bhushan Mahajan on 30/09/21.
//

import UIKit

class AccountActivityCell: UITableViewCell {
    
    static let identifier = "cell"
    
    var actionKindLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.grey()
        label.textColor = .white
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    var hashLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.grey()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
        contentView.backgroundColor = UIColor.grey()
        contentView.addSubview(actionKindLabel)
        actionKindLabel.anchor(top: contentView.topAnchor, paddingTop: 0, left: contentView.leftAnchor, paddingLeft: 0, right: contentView.rightAnchor, paddingRight: 0, height: 40)
        
        contentView.addSubview(hashLabel)
        hashLabel.anchor(top: actionKindLabel.bottomAnchor, paddingTop: 0, left: contentView.leftAnchor, paddingLeft: 0, right: contentView.rightAnchor, paddingRight: 0, height: 40)
    }
}
