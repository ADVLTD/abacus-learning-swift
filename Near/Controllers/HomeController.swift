//
//  HomeController.swift
//  Near
//
//  Created by Bhushan Mahajan on 24/09/21.
//

import UIKit
import AVFoundation
import AVKit

class HomeController: UITableViewController {
    
    //MARK: - Properties/Variables
    
    let near = NearRestAPI()
    var videoIdForFunction: String?
    
    var playerViewController = AVPlayerViewController()
    var playerView = AVPlayer()
    
    var videoId = ["01", "02", "03", "04"]
    var videoTitle = ["Near Video 1", "Near Video 2", "Near Video 3", "Near Video 4"]
    var videoURL = [
        "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4",
        "https://www.appsloveworld.com/wp-content/uploads/2018/10/640.mp4",
        "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
        "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4"
    ]
    
    //MARK: - Init Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeController()
        configureNavigationBar()
    }
    
    //MARK: - TableView Functions
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoURL.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoCellTableViewCell.identifier, for: indexPath) as! VideoCellTableViewCell
        cell.customVideoCellInit(title: videoTitle[indexPath.row], videoURL: videoURL[indexPath.row], videoId: videoId[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        playVideo(videoURL: videoURL[indexPath.row])
        self.videoIdForFunction = videoId[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    //MARK: - Configuration Functions
    
    func configureHomeController() {
        view.backgroundColor = UIColor.grey()
        
        tableView.backgroundColor = UIColor.grey()
        tableView.register(VideoCellTableViewCell.self, forCellReuseIdentifier: VideoCellTableViewCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Home"
        navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))?.withTintColor(.link, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(logOutButtonTapped)), UIBarButtonItem(image: UIImage(systemName: "gear", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))?.withTintColor(.link, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(settingsButtonTapped))]
    }
    
    //MARK: - Helper Functions
    
    func playVideo(videoURL: String) {
        guard let url = URL(string: videoURL) else  { return }
        playerView = AVPlayer(url: url)
        playerViewController.player = playerView
        self.present(playerViewController, animated: true, completion: nil)
        videoEndingNotification()
        self.playerViewController.player?.play()
    }
    
    func videoEndingNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    func showAlert(title: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Selector Functions
    
    @objc private func logOutButtonTapped() {
        let vc = CreateAccountController()
        navigationController?.setViewControllers([vc], animated: true)
        
        UserDefaults.standard.removeObject(forKey: Constants.nearAccountName.rawValue)
        UserDefaults.standard.removeObject(forKey: Constants.nearPublicKey.rawValue)
        UserDefaults.standard.removeObject(forKey: Constants.nearPrivateKey.rawValue)
    }
    
    @objc private func settingsButtonTapped() {
        let settings = SettingsController()
        navigationController?.pushViewController(settings, animated: true)
    }
    
    @objc private func videoDidEnd() {
        dismiss(animated: true)
        NotificationCenter.default.removeObserver(self)
        let accountName = UserDefaults.standard.string(forKey: Constants.nearAccountName.rawValue)
        let privateKey = UserDefaults.standard.string(forKey: Constants.nearPrivateKey.rawValue)
        near.viewUserWatchHistory(accountName: accountName!, videoId: self.videoIdForFunction!) { result in
            switch result {
            case .success(let response):
                if response == false {
                    self.near.saveUserVideoDetails(accountName: accountName!, videoId: self.videoIdForFunction!, privateKey: privateKey!) { sucess in
                        self.near.sendToken(accountName: accountName!, videoId: self.videoIdForFunction!, privateKey: privateKey!) { success in
                            DispatchQueue.main.async {
                                if sucess {
                                    let vc = SettingsController()
                                    vc.getBalance()
                                    self.showToast(message: "Near token added to your wallet.")
                                } else {
                                    self.showAlert(title: "Error", message: "Something went wrong. Please try again", actionTitle: "ok")
                                }
                            }
                        }
                    }
                } else if response == true {
                    DispatchQueue.main.async {
                        self.showToast(message: "No reward for this video will be awarded as You have already watched this video.")
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
