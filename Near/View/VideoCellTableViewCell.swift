//
//  VideoCellTableViewCell.swift
//  Near
//
//  Created by Bhushan Mahajan on 29/09/21.
//

import UIKit
import AVKit

class VideoCellTableViewCell: UITableViewCell {
    
    static let identifier = "videoCell"
    
    var videoTitleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.grey()
        label.textColor = .white
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    var thumbNailImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.grey()
        iv.layer.cornerRadius = 10
        iv.layer.masksToBounds = true
        return iv
    }()
    var playButton: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "play.fill")
        return iv
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
        
        contentView.addSubview(videoTitleLabel)
        videoTitleLabel.anchor(top: contentView.topAnchor, paddingTop: 6, left: contentView.leftAnchor, right: contentView.rightAnchor)
        
        contentView.addSubview(thumbNailImageView)
        thumbNailImageView.anchor(top: videoTitleLabel.bottomAnchor, paddingTop: 6, left: contentView.leftAnchor, paddingLeft: 6, right: contentView.rightAnchor, paddingRight: 6, bottom: contentView.bottomAnchor, paddingBottom: 6)
        
        thumbNailImageView.addSubview(playButton)
        playButton.anchor(width: 30, height: 30)
        playButton.centerXAnchor.constraint(equalTo: thumbNailImageView.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: thumbNailImageView.centerYAnchor).isActive = true
    }
    
    func customVideoCellInit(title: String, videoURL: String, videoId: String) {
        self.videoTitleLabel.text = title
        guard let url = URL(string: videoURL) else { return }
        self.getThumbnailFromVideoURL(url: url) { thumbnail in
            self.thumbNailImageView.image = thumbnail
        }
    }
    
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
