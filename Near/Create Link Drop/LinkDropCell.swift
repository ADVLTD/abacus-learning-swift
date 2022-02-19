import UIKit

class LinkDropCell: UITableViewCell {
   
   //MARK: - Properties/Variables
   
   //Singleton instance of identifier used to identify tableview cell.
   static let identifier = "cell"
   
   //Amount label used to display the amount of the transaction, configured using anonymous closure pattern.
   let ammountLabel: UILabel = {
      let label = UILabel()
      label.numberOfLines = 0
      label.textColor = .white
      return label
   }()
   
   let timeLabel: UILabel = {
      let label = UILabel()
      label.numberOfLines = 0
      label.textColor = .white
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
      ammountLabel.anchor(top: contentView.topAnchor, paddingTop: 5, left: contentView.leftAnchor, paddingLeft: 10, right: contentView.rightAnchor, paddingRight: 10, height: 40)
      
      //Time label constraints
      contentView.addSubview(timeLabel)
      timeLabel.anchor(top: ammountLabel.bottomAnchor, paddingTop: 5, left: contentView.leftAnchor, paddingLeft: 10, right: contentView.rightAnchor, paddingRight: 10, height: 40)
   }
   
   //Function for converting timestamp from milisecond to standard date format.
   func assignDateAndTime(timeStamp: Double) {
      
      //Converting the timestamp from milisecond to minutes.
      let converted = NSDate(timeIntervalSince1970: timeStamp / 1000)
      let dateFormatter = DateFormatter()
      
      //Setting the timezone for the device.
      dateFormatter.timeZone = NSTimeZone.local
      
      //Setting the format of the date and time to be displayed accordingly.
      dateFormatter.dateFormat = "dd/MMMM/yyyy hh:mm a"
      let time = dateFormatter.string(from: converted as Date)
      
      //Setting the date and time converted from timestamp to the timeLabel.
      timeLabel.text = "Created on: \(time)"
   }
}
