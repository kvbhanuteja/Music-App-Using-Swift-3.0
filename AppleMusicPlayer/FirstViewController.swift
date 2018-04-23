//
//  FirstViewController.swift
//  AppleMusicPlayer
//
//  Created by Bhanuteja on 23/05/17.
//  Copyright © 2017 Bhanuteja. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import MediaToolbox

var songsArray :[String] = []
var audioPlayer = AVAudioPlayer()
var thisSong = 0
var audioStuffed = false
var songsurl :[String] = []
var isPaused :Bool = false
var avPlayer: AVPlayer?
let player = MPMusicPlayerController.systemMusicPlayer

class FirstViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,AVAudioPlayerDelegate,MPMediaPickerControllerDelegate{
    
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.beginReceivingRemoteControlEvents()
        songsArray.removeAll()
        songsurl.removeAll()
        _ = MPMediaQuery.songs()
        switch MPMediaLibrary.authorizationStatus() {
        case .restricted , .denied :
            let alertController = UIAlertController(title: "alert", message: "You have restricted the access to read songs from device", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(ok)
            self.present(alertController, animated: true, completion: nil)
        case .authorized , .notDetermined :
            gettingSong()
        }
        tableview.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = songsArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        thisSong = indexPath.row
        let mediaItems = MPMediaQuery.songs().items
        let query = MPMediaQuery.songs()
        let predicateByGenre = MPMediaPropertyPredicate(value: "All", forProperty: MPMediaItemPropertyGenre)
        query.filterPredicates = NSSet(object: predicateByGenre) as? Set<MPMediaPredicate>
        let mediaCollection = MPMediaItemCollection(items: [mediaItems![thisSong]])
        player.setQueue(with: mediaCollection)
        self.tabBarController?.selectedIndex = 1
        isPaused = false
        player.play()
    }
    
    func nextTrackCommandSelector(){
        thisSong += 1
        self.tableview.reloadData()
    }
    
    func prevTrackCommandSelector(){
        thisSong -= 1
        self.tableview.reloadData()
    }
    func gettingSong()
    {
        songsurl.removeAll()
        songsArray.removeAll()
        
        let myPlaylistQuery = MPMediaQuery.songs()
        let playlists = myPlaylistQuery.collections
        if playlists?.count != 0 && playlists != nil{
        for playlist in playlists! {
            let songs = playlist.items
            print(songs)
            for song in songs {
                let songTitle = song.value(forProperty: MPMediaItemPropertyTitle)
                var songName = songTitle! as! String
                songName =  songName.replacingOccurrences(of: "'", with: "")
                songName = songName.capitalizingFirstLetter()
                if !(songsArray.contains(songName)){
                    songsArray.append(songName)
                    audioStuffed = true
                }
            }
        }
            self.tableview.reloadData()
        }else{
            let alertController = UIAlertController(title: "Music Player Alert", message: "You don't have songs in your device", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(ok)
           present(alertController, animated: true, completion: nil)
        }
        }
}
extension String {
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
