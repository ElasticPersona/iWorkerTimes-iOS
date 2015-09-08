//
//  ViewController.swift
//  iWorkerTimes
//
//  Created by Shuhei Hasegawa on 2015/08/31.
//  Copyright (c) 2015年 Shuhei Hasegawa. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class PunchViewController: UIViewController {

    var works = [[String:AnyObject]]()
    
    // 打刻ボタンでリクエストを送るURL
    let urlPostString = "http://52.68.68.148:3000/work"
    // 今日の打刻状況を取得するURL
    let urlTodayString = "http://52.68.68.148:3000/work/today"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.fetchTodayWorks()
        
        // スワイプ認識.
        let pageSwipe = UISwipeGestureRecognizer(target: self, action: "swipeGesture:")
        pageSwipe.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(pageSwipe)
    }
    
    /*
    スワイプイベント
    打刻画面から勤怠一覧画面へと遷移
    */
    internal func swipeGesture(sender: UISwipeGestureRecognizer){
        let touches = sender.numberOfTouches()
        println("swipeGesture:")
        //swipeLabel.text = "\(touches)"
        performSegueWithIdentifier("WorkTableViewSegue",sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func punch(sender: AnyObject) {
        
        // ユーザ名を付加させてリクエストを送る
        let defaults = NSUserDefaults.standardUserDefaults()
        let userName = defaults.stringForKey("userName")
        let params = [
            "userName" : userName!,
            "comment" : "備考"
        ]
        
        request(.POST, urlPostString, parameters: params, encoding: .JSON)
            .responseJSON {
                (request, response, data, error) -> Void in
                
        }
        
        let alert = UIAlertView()
        alert.title = "メッセージ"
        alert.message = "打刻しました。"
        alert.addButtonWithTitle("OK")
        alert.show()
        println("打刻しました。")
    }
    
    // 勤怠一覧画面に遷移する場合に値を渡したい場合はここ
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
        if segue.identifier == "WorkTableViewSegue" {
        }
        if segue.identifier == "SettingTableViewSegue" {
        }
    }
    
    func fetchTodayWorks() {
        /*
        let url = NSURL(string: urlTodayString)
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let dataTask = session.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            
            if (error == nil) {
                let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as! [String:AnyObject]
                
                let results = json["results"] as! [[String:AnyObject]]
                
                self.works = results
                
            }
        })
        dataTask.resume()
        */
        
        // ユーザ名を付加させてリクエストを送る
        let defaults = NSUserDefaults.standardUserDefaults()
        let userName = defaults.stringForKey("userName")
        let params = [
            "userName" : userName!
        ]
        
        request(.POST, urlTodayString, parameters: params, encoding: .JSON)
            .responseJSON {
                (_, _, resJson, error) -> Void in
                if (error == nil) {
                    let data = JSON(resJson!)
                    println(data["results"]["workIn"])
                    println(data["results"]["workOut"])
                    
                    
                    
                    
                    let image = UIImage(named: "punchOut")!
                    let imageButton = UIButton()
                    imageButton.setImage(image, forState: .Normal)
                    
                }
        }
        
    }

}

