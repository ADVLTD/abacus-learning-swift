//
//  LinkDropCell.swift
//  Near
//
//  Created by Bhushan Mahajan on 07/10/21.
//

import UIKit

class LinkDropCell: UITableViewCell {

    let near = NearRestAPI()
    static let identifier = "cell"
    
    let ammountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
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
        
        contentView.addSubview(ammountLabel)
        ammountLabel.anchor(top: contentView.topAnchor, paddingTop: 10, left: contentView.leftAnchor, paddingLeft: 10, right: contentView.rightAnchor, paddingRight: 10, height: 45)
    }
}
