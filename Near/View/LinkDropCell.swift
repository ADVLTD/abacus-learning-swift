//
//  LinkDropCell.swift
//  Near
//
//  Created by Bhushan Mahajan on 07/10/21.
//

import UIKit

class LinkDropCell: UITableViewCell {

    //MARK: - Properties/Variables
    
    //Singleton instance of identifier used to identify tableview cell.
    static let identifier = "cell"
    //Amount label used to display the amount of the transaction, configured using anonymous closure pattern.
    let ammountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: Init Functions
    
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
    
    //MARK: Configuration Functions
    
    //Given all the constraints and the background color for the elements displayed on the linkdrop tableview.
    func configureCell() {
        contentView.backgroundColor = UIColor.grey()
        //Amount label constraints
        contentView.addSubview(ammountLabel)
        ammountLabel.anchor(top: contentView.topAnchor, paddingTop: 10, left: contentView.leftAnchor, paddingLeft: 10, right: contentView.rightAnchor, paddingRight: 10, height: 45)
        contentView.addSubview(timeLabel)
        timeLabel.anchor(top: ammountLabel.bottomAnchor, paddingTop: 10, left: contentView.leftAnchor, paddingLeft: 10, right: contentView.rightAnchor, paddingRight: 10, height: 45)
    }
    
    func assignDateAndTime(timeStamp: Double) {
        let date = Date(timeIntervalSince1970: timeStamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.dateStyle = DateFormatter.Style.short
        let localDate = dateFormatter.string(from: date)
        timeLabel.text = localDate
    }
}
