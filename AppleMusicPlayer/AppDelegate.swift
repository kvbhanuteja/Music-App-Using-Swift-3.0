//
//  AppDelegate.swift
//  AppleMusicPlayer
//
//  Created by Bhanuteja on 23/05/17.
//  Copyright © 2017 Bhanuteja. All rights reserved.
//

import UIKit
import MediaPlayer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var imageView : UIImageView?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if self.window!.rootViewController as? UITabBarController != nil {
            let tababarController = self.window!.rootViewController as! UITabBarController
            tababarController.selectedIndex = 0
        }
        UIApplication.shared.beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
       
        let getAvAudioSession = AVAudioSession.sharedInstance()
        do {
            try getAvAudioSession.setActive(true)
            try getAvAudioSession.setCategory(AVAudioSessionCategoryPlayback)
        }catch{
            print(error)
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        let image: UIImage = UIImage(named: "player")!
        imageView = UIImageView(image: image)
        imageView?.frame = (self.window?.frame)!
        self.window?.addSubview(imageView!)
        UIApplication.shared.beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if(imageView != nil) {
            imageView?.removeFromSuperview()
            imageView = nil
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        let player = MPMusicPlayerController.systemMusicPlayer
        player.pause()
        print("i have killed")
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

