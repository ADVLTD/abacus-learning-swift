import UIKit

class AccountActivityCell: UITableViewCell {
    
    //MARK: - Properties/Variables
    
    //Singleton instance of identifier used to identify tableview cell.
    static let identifier = "cell"
    
    //Action kind label used to display the action_kind of the transaction, configured using anonymous closure pattern.
    var actionKindLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.grey()
        label.textColor = .white
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17)
        return label
    }()

    //MARK: - Init Functions
    
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
    
    //MARK: - Configuration Functions
    
    //Given all the constraints and the background color for the elements displayed on the Home Screen.
    func configureCell() {
        contentView.backgroundColor = UIColor.grey()
        
        //ActionKind label constraints
        contentView.addSubview(actionKindLabel)
        actionKindLabel.anchor(top: contentView.topAnchor, paddingTop: 0, left: contentView.leftAnchor, paddingLeft: 32, right: contentView.rightAnchor, paddingRight: 32, height: 40)
    }
}
