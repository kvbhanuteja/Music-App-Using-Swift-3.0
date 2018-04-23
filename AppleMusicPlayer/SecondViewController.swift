//
//  SecondViewController.swift
//  AppleMusicPlayer
//
//  Created by Bhanuteja on 23/05/17.
//  Copyright © 2017 Bhanuteja. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import MediaPlayer
import EventKit
import EventKitUI

class SecondViewController: UIViewController,AVAudioPlayerDelegate {

    var timer: Timer?
    let audioInfo = MPNowPlayingInfoCenter.default()
    var nowPlayingInfo:[NSObject:AnyObject] = [:]
    
    @IBOutlet weak var songName1: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var totaltime: UILabel!
    @IBOutlet weak var currenttime: UILabel!
    @IBOutlet weak var slideroutlet: UISlider!
    @IBOutlet weak var playAndpauseButton: UIButton!
    @IBOutlet weak var songname: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    let eventType =  UIEvent()
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var labelFrame1 = songname.frame
        var labelFrame2 = songName1.frame
        var viewFrame = backgroundView.frame
        let offset:CGFloat = 10
        
        labelFrame2.origin.x = labelFrame1.origin.x + labelFrame1.size.width + offset
        
       // songName1.frame = labelFrame2
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
        endTimeLabel.text = "00:00:00"
        startTimeLabel.text = "00:00:00"
        if songsArray.count != 0{
        songname.text = songsArray[thisSong]
        songName1.text = songsArray[thisSong]
        }
        if songsArray.count == 0{
            endTimeLabel.text = "00:00:00"
            startTimeLabel.text = "00:00:00"
            playAndpauseButton.setImage(UIImage(named:"play"), for: .normal)
            songName1.isHidden = true
        }else{
        playAndpauseButton.setImage(UIImage(named:"pause"), for: .normal)
        Timer.scheduledTimer(timeInterval: 0.03, target: self, selector: #selector(self.moveSongname), userInfo: nil, repeats: true);
        }
    }
    
    @objc func moveSongname() {
        if isPaused {
            return
        }
        startTimeLabel.text = stringFromTimeInterval(interval: player.currentPlaybackTime) as String
        slideroutlet.maximumValue = Float((player.nowPlayingItem?.playbackDuration)!)
        endTimeLabel.text = stringFromTimeInterval(interval: (player.nowPlayingItem?.playbackDuration)!) as String
        slideroutlet.setValue(Float(player.currentPlaybackTime), animated: false)
        
        if  player.currentPlaybackTime == (player.nowPlayingItem?.playbackDuration)! - 0.0000060{
            nextTrack()
        }

        let labelFrame1 = songname.frame
        _ = songName1.frame
        let viewFrame = backgroundView.frame
        if labelFrame1.origin.x + labelFrame1.size.width <= viewFrame.size.width { // label is smaller
            
        }
        if ((songname.text?.count) as! Int) >= 50{
            songName1.isHidden = false
        if (songname.frame.origin.x + songname.frame.width) > backgroundView.frame.origin.x && songname.frame.origin.x < songName1.frame.origin.x
        {
            songname.frame.origin.x = songname.frame.origin.x - 0.5
            songName1.frame.origin.x = songname.frame.origin.x + songname.frame.size.width + 50

        }else {
            
            songName1.frame.origin.x = songName1.frame.origin.x - 0.5
            songname.frame.origin.x = songName1.frame.origin.x - songName1.frame.size.width
        }
        }else{
            songName1.isHidden = true
        }
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
     override func remoteControlReceived(with event: UIEvent?) {
    }
    
    
    @IBAction func playAndPause(_ sender: Any) {
        
        if (isPaused) && audioStuffed == true {
            playAndpauseButton.setImage(UIImage(named:"pause"), for: .normal)
            isPaused = false
            player.play()
        }else{
            if audioStuffed == true{
            playAndpauseButton.setImage(UIImage(named:"play"), for: .normal)
            isPaused = true
            player.pause()
            }
            
        }
    }
    
    @IBAction func prev(_ sender: Any) {
        prevTrack()
    }
   
    @IBAction func Next(_ sender: Any) {
        nextTrack()
    }
    @IBAction func sliderAction(_ sender: UISlider) {
        player.currentPlaybackTime = TimeInterval(sender.value)
    }
    
    func playThisSong(thisOne:Int){
        songname.text = songsArray[thisOne]
        songName1.text = songsArray[thisOne]
        player.play()
    }
    
    func didPlayToEnd() {
        self.nextTrack()
    }
    
    func nextTrack(){
        if thisSong < songsArray.count-1 && audioStuffed == true
        {
            slideroutlet.minimumValue = 0.0

            playThisSong(thisOne: thisSong + 1)
            thisSong += 1
            isPaused = false
            let mediaItems = MPMediaQuery.songs().items
            let query = MPMediaQuery.songs()
            let predicateByGenre = MPMediaPropertyPredicate(value: "All", forProperty: MPMediaItemPropertyGenre)
            query.filterPredicates = NSSet(object: predicateByGenre) as? Set<MPMediaPredicate>
            let mediaCollection = MPMediaItemCollection(items: [mediaItems![thisSong]])
            player.setQueue(with: mediaCollection)
            player.play()
            }
        else
        {
           player.currentPlaybackTime = 0
        }

    }
    func prevTrack(){
        if thisSong != 0 && audioStuffed == true{
            playThisSong(thisOne: thisSong - 1)
            thisSong -= 1
            isPaused = false
            let mediaItems = MPMediaQuery.songs().items
            let query = MPMediaQuery.songs()
            let predicateByGenre = MPMediaPropertyPredicate(value: "All", forProperty: MPMediaItemPropertyGenre)
            query.filterPredicates = NSSet(object: predicateByGenre) as? Set<MPMediaPredicate>
            let mediaCollection = MPMediaItemCollection(items: [mediaItems![thisSong]])
            player.setQueue(with: mediaCollection)
            player.play()
        }else{
            player.currentPlaybackTime = 0
        }
        
        
    }

    
    func tick(){
        if(avPlayer?.currentTime().seconds == 0.0){
            songname.alpha = 1
        }else{
            //songname.alpha = 0
        }
        
        if(isPaused == false){
            if(avPlayer?.rate == 0){
                avPlayer?.play()
                songname.alpha = 1
            }else{
                //songname.alpha = 0
            }
        }
        
        if((avPlayer?.currentItem?.asset.duration) != nil){
            let currentTime1 : CMTime = (avPlayer?.currentItem?.asset.duration)!
            let seconds1 : Float64 = CMTimeGetSeconds(currentTime1)
            let time1 : Float = Float(seconds1)
            slideroutlet.minimumValue = 0
            slideroutlet.maximumValue = time1
            let currentTime : CMTime = (avPlayer?.currentTime())!
            let seconds : Float64 = CMTimeGetSeconds(currentTime)
            let time : Float = Float(seconds)
            self.slideroutlet.value = time
            totaltime.text =  self.formatTimeFromSeconds(totalSeconds: Int32(Float(Float64(CMTimeGetSeconds((avPlayer?.currentItem?.asset.duration)!)))))
            currenttime.text = self.formatTimeFromSeconds(totalSeconds: Int32(Float(Float64(CMTimeGetSeconds((avPlayer?.currentItem?.currentTime())!)))))
            
        }else{
            slideroutlet.value = 0
            slideroutlet.minimumValue = 0
            slideroutlet.maximumValue = 0
            totaltime.text = "Live stream \(self.formatTimeFromSeconds(totalSeconds: Int32(CMTimeGetSeconds((avPlayer?.currentItem?.currentTime())!))))"
        }
    }
    

    func formatTimeFromSeconds(totalSeconds: Int32) -> String {
        let seconds: Int32 = totalSeconds%60
        let minutes: Int32 = (totalSeconds/60)%60
        let hours: Int32 = totalSeconds/3600
        return String(format: "%02d:%02d:%02d", hours,minutes,seconds)
    }
    func stringFromTimeInterval(interval: TimeInterval) -> NSString {
        let ti = NSInteger(interval)
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        return NSString(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
    }
}

