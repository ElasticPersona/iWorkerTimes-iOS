//
//  WorkTableViewController.swift
//  iWorkerTimes
//
//  Created by Shuhei Hasegawa on 2015/08/31.
//  Copyright (c) 2015年 Shuhei Hasegawa. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class WorkTableViewController: UITableViewController {
    
    // セクションの数
    let sectionNum = 1
    // 1セクションあたりのセルの行数(データ数)
    var cellNum = 3
    
    // 取得するAPI
    //let urlString = "http://api.openweathermap.org/data/2.5/forecast?units=metric&q=Tokyo"
    let urlString = "http://52.68.68.148:3000"
    
    // セルの中身
    var works = [[String:AnyObject]]()
    var cellItems = NSMutableArray() //TODO Del
    var cellInfo = [[String:JSON]]() //TODO Del
    
    // ロード中かどうか
    var isInLoad = false
    
    // 選択されたセルの情報
    var selectedRowNum: Int!
    var index = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // json取得->tableに突っ込む
        self.fetchWorks()
        //makeTableData()
        
        // プルダウンでリロード機能
        addRefreshControl()
        
    }
    
    // プルダウンでリロード機能を付加
    func addRefreshControl() {
        var refresh = UIRefreshControl()
        // ロード時に表示される文字を設定
        refresh.attributedTitle = NSAttributedString(string: "Now Loading...")
        // プルダウン時に呼び出されるメソッドを設定
        refresh.addTarget(self, action: "pullToRefresh", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refresh
    }
    
    
    // リロード時の処理
    func pullToRefresh() {
        
        // tableに突っ込む用のデータを作成
        //makeTableData()
        self.fetchWorks()
        
        // 再度tableに情報を突っ込む
        self.tableView.reloadData()
        self.index++
        println("refresh: \(self.index)")
    }
    
    
    // json取得->tableに突っ込む
    func makeTableData() {
        self.isInLoad = true
        var url = NSURL(string: self.urlString)!
        var task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: {data, response, error in
            // リソースの取得が終わると、ここに書いた処理が実行される
            var json = JSON(data: data)
            
            // 各セルに情報を突っ込む
            for var i = 0; i < self.cellNum; i++ {
                var name = json[i]["name"]
                var in_time = json[i]["in"]
                var out_time = json[i]["out"]
                
                var info = "\(in_time), \(out_time)"
                self.cellItems[i] = info
            }
            
            for (key: String, value: JSON) in json {
                var cellJson = [
                    "name" : value["name"],
                    "in" : value["in"],
                    "out" : value["out"],
                    "comment" : value["comment"]
                ]
                //println(cellJson)
                self.cellInfo.append(cellJson)
            }
            // ロードが完了したので、falseに
            self.isInLoad = false
        })
        task.resume()
        
        // 読み込みが終わるまで待機
        // (ゆる募)
        // 下の解決策以外に何か方法があればと。。。
        // jsonの取得に非同期通信を使ってるので、読み込むまで待ってからじゃないと
        // cellに値が入らない。同期通信使えって話もあるけど今後の拡張を考えてNSURLSession使ってます(^_^;)
        while isInLoad {
            usleep(10)
            index++
            // println("load\(index)")
        }
        // ロードが終わったことを通知
        refreshControl?.endRefreshing()
    }
    
    func fetchWorks() {
        self.isInLoad = true
        
        let url = NSURL(string: urlString)
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let dataTask = session.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in

            if (error == nil) {
                let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as! [String:AnyObject]
                
                let results = json["results"] as! [[String:AnyObject]]
                
                self.works = results
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            }
            // ロードが完了したので、falseに
            self.isInLoad = false
        })
        dataTask.resume()
        
        // 読み込みが終わるまで待機
        // (ゆる募)
        // 下の解決策以外に何か方法があればと。。。
        // jsonの取得に非同期通信を使ってるので、読み込むまで待ってからじゃないと
        // cellに値が入らない。同期通信使えって話もあるけど今後の拡張を考えてNSURLSession使ってます(^_^;)
        //while isInLoad {
        //    usleep(10)
        //    index++
            // println("load\(index)")
        //}
        // ロードが終わったことを通知
        refreshControl?.endRefreshing()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // 戻り値を変更
    // セクションの数
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return self.sectionNum
    }
    
    // 1セクションあたりのセルの行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.works.count
    }
    
    // セルの中身を設定
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("workTableCell", forIndexPath: indexPath) as! UITableViewCell
        // セルの中身を設定
        let work = works[indexPath.row]
        println(work["workIn"])
        
        // タイムゾーンを言語設定にあわせる
        let iso8601Formatter = NSDateFormatter()
        iso8601Formatter.locale = NSLocale(localeIdentifier: "ja_JP")
        //iso8601Formatter.dateFormat = "yyyy年MM月dd日 HH時mm分ss秒.SSSZ"
        iso8601Formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        // 上記の形式の日付文字列を取得します
        var workIn = NSDate()
        var workOut = NSDate()
        
        if (work["workIn"] != nil) {
                workIn = iso8601Formatter.dateFromString(work["workIn"]! as! String)!
        } else {
        }
        if (work["workOut"] != nil) {
                workOut = iso8601Formatter.dateFromString(work["workOut"]! as! String)!
        } else {
        }
        
        cell.textLabel?.text = "\(workIn)" + "\(workOut)"
        cell.detailTextLabel?.text = work["workInComment"] as? String
        
        return cell
    }
    
    // セル選択時の挙動
    override func tableView(tableView: UITableView?, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 選択されたセルの情報を記録
        selectedRowNum = indexPath.row
        
        // DetailViewController へ遷移するために Segue を呼び出す
        performSegueWithIdentifier("DetailTableViewControllerSegue", sender: selectedRowNum)
    }
    
    // Segue準備
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "DetailTableViewControllerSegue") {
            
            
            // 遷移先のViewContollerにセルの情報を渡す
            let cellNum = sender as! Int
            let DetailVC : DetailTableViewController = segue.destinationViewController as! DetailTableViewController
            DetailVC.detailWorks = self.works[cellNum] as [String:AnyObject]
        }
    }
    
}
