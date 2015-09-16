//
//  AppDelegate.swift
//  iWorkerTimes
//
//  Created by Shuhei Hasegawa on 2015/08/31.
//  Copyright (c) 2015年 Shuhei Hasegawa. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Basic認証情報
        let user = "maccha"
        let password = "maccha"
        
        let plainString = "\(user):\(password)" as NSString
        let plainData = plainString.dataUsingEncoding(NSUTF8StringEncoding)
        let base64String = plainData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.allZeros)
        
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = ["Authorization": "Basic " + base64String!]
        
        // ユーザのpush通知許可をもらうための設定
        application.registerUserNotificationSettings(
            UIUserNotificationSettings(forTypes:
                UIUserNotificationType.Sound
              | UIUserNotificationType.Badge
              | UIUserNotificationType.Alert, categories: nil
            )
        )
        
        // アプリを終了していた際に、通知からの復帰をチェック
        if let notification = launchOptions?[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification {
            localPushRecieve(application, notification: notification)
        }
        // バッジをリセット
        application.applicationIconBadgeNumber = 0
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        // push通知設定
        // 登録済みのスケジュールをすべてリセット
        application.cancelAllLocalNotifications()
        
        var notification = UILocalNotification()
        notification.alertAction = "アプリに戻る"
        // push通知メッセージ
        notification.alertBody = "定時になりました"
        // 通知する日時を設定
        notification.fireDate = Util.nextFireDate()
        notification.soundName = UILocalNotificationDefaultSoundName
        // アイコンバッジに1を表示
        notification.applicationIconBadgeNumber = 1
        // あとのためにIdを割り振っておく
        notification.userInfo = ["notifyId": "punch_update"]
        application.scheduleLocalNotification(notification)
        
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        // アプリがActiveな状態で通知を発生させた場合にも呼ばれるのでActiveでない場合のみ実行するように
        if application.applicationState != .Active {
            localPushRecieve(application, notification: notification)
        }
    }
    
    func localPushRecieve(application: UIApplication, notification: UILocalNotification) {
        if let userInfo = notification.userInfo {
            switch userInfo["notifyId"] as? String {
            case .Some("push_update"):
                reloadFromPush()
                break
            default:
                break
            }
            // バッジをリセット
            application.applicationIconBadgeNumber = 0
            // 通知領域からこの通知を削除
            application.cancelLocalNotification(notification)
        }
    }
    
    func reloadFromPush() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let punchViewController = mainStoryboard.instantiateViewControllerWithIdentifier("PunchViewController") as! PunchViewController
        
        // punchViewController.setupLinks(forceReload: true)
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

