//
//  VideoCellTableViewCell.swift
//  Near
//
//  Created by Bhushan Mahajan on 29/09/21.
//

import UIKit
import AVKit

class VideoCellTableViewCell: UITableViewCell {
    
    //MARK: - Properties/Variables
    
    //Singleton instance of identifier used to identify tableview cell.
    static let identifier = "videoCell"
    
    //Video title label configured using anonymous closure pattern
    var videoTitleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.grey()
        label.textColor = .white
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    //Video thumbnail configured using anonymous closure pattern
    var thumbNailImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.grey()
        iv.layer.cornerRadius = 10
        iv.layer.masksToBounds = true
        return iv
    }()
    //Play button configured using anonymous closure pattern
    var playButton: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "play.fill")
        return iv
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
       
        //Video Title Constraints
        contentView.addSubview(videoTitleLabel)
        videoTitleLabel.anchor(top: contentView.topAnchor, paddingTop: 6, left: contentView.leftAnchor, right: contentView.rightAnchor)
        
        //Video thumbnail Constraints
        contentView.addSubview(thumbNailImageView)
        thumbNailImageView.anchor(top: videoTitleLabel.bottomAnchor, paddingTop: 6, left: contentView.leftAnchor, paddingLeft: 6, right: contentView.rightAnchor, paddingRight: 6, bottom: contentView.bottomAnchor, paddingBottom: 6)
        
        //Play button Constraints
        thumbNailImageView.addSubview(playButton)
        playButton.anchor(width: 30, height: 30)
        playButton.centerXAnchor.constraint(equalTo: thumbNailImageView.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: thumbNailImageView.centerYAnchor).isActive = true
    }
    
    //Passing all the data to the elements to be displayed on the screen. Elements are play button, video title and video thumbnail.
    func customVideoCellInit(title: String, videoURL: String, videoId: String) {
        self.videoTitleLabel.text = title
        guard let url = URL(string: videoURL) else { return }
        self.getThumbnailFromVideoURL(url: url) { thumbnail in
            self.thumbNailImageView.image = thumbnail
        }
    }
    
    //Getting the thumbnail from the video url using AVFoundation.
    func getThumbnailFromVideoURL(url: URL, completion: @escaping ((_ image: UIImage) -> Void)) {
        DispatchQueue.global().async {

            let asset = AVAsset(url: url)
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset)

            avAssetImageGenerator.appliesPreferredTrackTransform = true
            let thumbnailTime = CMTimeMake(value: 6, timescale: 2)

            do {
                let cgThumbnailImage = try avAssetImageGenerator.copyCGImage(at: thumbnailTime, actualTime: nil)
                let thumbImage = UIImage(cgImage: cgThumbnailImage)

                DispatchQueue.main.async {
                    completion(thumbImage)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
