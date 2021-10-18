//
//  HomeController.swift
//  Near
//
//  Created by Bhushan Mahajan on 24/09/21.
//

import UIKit
import AVFoundation
import AVKit

class HomeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Properties/Variables
    
    //Variables for AVKit to play the videos
    var playerViewController = AVPlayerViewController()
    var playerView = AVPlayer()
    
    //Variables for the Videos
    var videoIdForFunction: String?
    var videoId = ["1991", "2992", "3993", "4994"]
    var videoTitle = ["Near Video 1", "Near Video 2", "Near Video 3", "Near Video 4"]
    var videoURL = [
        "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4",
        "https://www.appsloveworld.com/wp-content/uploads/2018/10/640.mp4",
        "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
        "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4"
    ]
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.grey()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(VideoCellTableViewCell.self, forCellReuseIdentifier: VideoCellTableViewCell.identifier)
        return tableView
    }()
    
    //MARK: - Init Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureNavigationBar()
        configureHomeController()
    }
    
    //MARK: - TableView Functions
    
    //Number of rows in the tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoURL.count
    }
    
    //Perticular cell for the row according to the array.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoCellTableViewCell.identifier, for: indexPath) as! VideoCellTableViewCell
        cell.customVideoCellInit(title: videoTitle[indexPath.row], videoURL: videoURL[indexPath.row], videoId: videoId[indexPath.row])
        return cell
    }
    
    //Function for action after selecting any row in the tableview
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        playVideo(videoURL: videoURL[indexPath.row])
        self.videoIdForFunction = videoId[indexPath.row]
    }
    
    //Row height for the row in the tableview.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    //MARK: - Configuration Functions
    
    //Function for configuration of the view
    func configureHomeController() {
       
        //Background color for view/home screen
        view.backgroundColor = UIColor.grey()
        
        //TableView background color
        tableView.backgroundColor = UIColor.grey()
        
        
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, paddingTop: 100, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor)
        
    }
    
    //Function to configure Navigation bar
    func configureNavigationBar() {
        
        //Sets title for navigation bar
        navigationItem.title = "Home"
        
        //Sets the font and textcolor of the title
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .bold)]
        
        //Sets the tint color of the navigationBar.
        navigationController?.navigationBar.barTintColor = UIColor.grey()

        //Sets buttons for settings and logout on navigation bar
        navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))?.withTintColor(.link, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(logOutButtonTapped)), UIBarButtonItem(image: UIImage(systemName: "gear", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))?.withTintColor(.link, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(settingsButtonTapped))]
    }
    
    //MARK: - Helper Functions
    
    //Function to play video in video player
    func playVideo(videoURL: String) {
       
        //Checking URL declared in an  array above in variables.
        guard let url = URL(string: videoURL) else  { return }
        
        //Passing the url to AVplayer to play video
        playerView = AVPlayer(url: url)
       
        //Setting the player to player controller to display the video
        playerViewController.player = playerView
        
        //Presenting the video player
        self.present(playerViewController, animated: true, completion: nil)
        
        //Setting the notification for observing of video ending.
        videoEndingNotification()
        
        //Plays the video
        self.playerViewController.player?.play()
    }
    
    //Function for notification for observing video ending
    func videoEndingNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    //MARK: Selector Functions
    
    //Action for Logout button
    @objc private func logOutButtonTapped() {
        
        //Navigate to Create account view.
        let vc = CreateAccountController()
        navigationController?.setViewControllers([vc], animated: true)
        
        //Removing all the saved data of user.
        UserDefaults.standard.removeObject(forKey: Constants.nearAccountName.rawValue)
        UserDefaults.standard.removeObject(forKey: Constants.nearPublicKey.rawValue)
        UserDefaults.standard.removeObject(forKey: Constants.nearPrivateKey.rawValue)
        UserDefaults.standard.removeObject(forKey: Constants.nearLinkDropArray.rawValue)
    }
    
    //Action for settings button
    @objc private func settingsButtonTapped() {
        
        //Navigate to settings view.
        let settings = SettingsController()
        navigationController?.pushViewController(settings, animated: true)
    }
    
    //    //Action for Video ending.
    @objc private func videoDidEnd() {
        
        //Video player removed from view.
        dismiss(animated: true)
        
        //Removed the notification observer after video ends.
        NotificationCenter.default.removeObserver(self)
        
        //Checking for nil value for accountname and privatekey.
        guard let accountName = UserDefaults.standard.string(forKey: Constants.nearAccountName.rawValue),
              let privateKey = UserDefaults.standard.string(forKey: Constants.nearPrivateKey.rawValue)
        else {
            showToast(message: "AccountName or PrivateKey not found.")
            return
        }
        
        //Using the RewardUser function to check for video watch history, if the user has watched the video then near is not awarded, if user is watching the video 1st time near will be awarded.
        NearRestAPI.shared.rewardUser(accountName: accountName, privateKey: privateKey, videoId: self.videoIdForFunction!) { result in
            
            //Using main thread as there is UI operation in this switch.
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response {
                        //If the response is true that means the near is added to the user account
                        self.showToast(message: "Near Token added to your account balance.")
                    } else {
                        //If the response is false that means the near is not awarded to the user account
                        self.showToast(message: "You have already watched this video!")
                    }
                case .failure(let error):
                    //Showing other error messages using this toast.
                    self.showToast(message: error.localizedDescription)
                }
            }
        }
    }
}
