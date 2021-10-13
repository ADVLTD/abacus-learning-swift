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
    var videoId = ["01111", "02222", "03333", "04444"]
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
    
    //Action for Video ending.
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
        
        //Using the viewWatchHistory function to check if the user has already watched the video.
        NearRestAPI.shared.viewUserWatchHistory(accountName: accountName, videoId: self.videoIdForFunction!) { result in
            switch result {
            
                //if the result from the server is success
            case .success(let response):
                
                //if the response is flase then the user has not watched the video and has to be awarded with near.
                if response == false {
                    
                    //Using the save history function to save the watch history of the currently watched video.
                    NearRestAPI.shared.saveUserVideoDetails(accountName: accountName, videoId: self.videoIdForFunction!, privateKey: privateKey) { success in
                       
                        //if user watch history saved successfully
                        if success {
                           
                            //Using the send token function to send reward to the user for watching the video
                            NearRestAPI.shared.sendToken(accountName: accountName, videoId: self.videoIdForFunction!, privateKey: privateKey) { success in
                              
                                //Using the main thread as there is Ui elements used.
                                DispatchQueue.main.async {
                                  
                                    //if the user gets the near token succesfully
                                    if success {
                                        let vc = SettingsController()
                                        vc.getBalance()
                                        self.showToast(message: "Near token added to your wallet.")
                                   
                                        //if the user gets the near token succesfully
                                    } else {
                                        self.showToast(message: "Something went wrong. Please try again")
                                    }
                                }
                            }
                        
                            //if user watch history did not save successfully showing error message.
                        } else {
                            DispatchQueue.main.async {
                                self.showToast(message: "Watch history did not save properly. Try again!")
                            }
                        }
                    }
                
                    //if the response is true then the user has watched the video near should not be awarded.
                } else if response == true {
                    DispatchQueue.main.async {
                        self.showToast(message: "No reward for this video will be awarded as You have already watched this video.")
                    }
                }
            
                //if the result from the server is failure
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
