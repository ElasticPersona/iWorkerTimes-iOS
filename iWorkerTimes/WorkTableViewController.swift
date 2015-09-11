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
    let urlString = "http://52.68.68.148:3000/work"
    
    // セルの中身
    var works = [Work]()
    
    // ロード中かどうか
    var isInLoad = false
    
    // 選択されたセルの情報
    var selectedRowNum: Int!
    var index = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // json取得->tableへ
        self.fetchWorks()
        
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
        
        // tableに表示するデータを作成
        self.works.removeAll()
        self.fetchWorks()
        
        // table情報を更新
        self.tableView.reloadData()
        self.index++
        println("refresh: \(self.index)")
    }
    
    
    // json取得->TableViewへ
    func fetchWorks() {
        self.isInLoad = true
        
        
        // ユーザ名を付加させてリクエストを送る
        let defaults = NSUserDefaults.standardUserDefaults()
        let userName = defaults.stringForKey("userName")
        let params = [
            "userName" : userName!
        ]
        
        request(.POST, urlString, parameters: params, encoding: .JSON)
            .responseJSON {
                (_, _, resJson, error) -> Void in
                if let workParamArray = resJson!["results"] as? Array<Dictionary<String,AnyObject>> {
                    for workParam in workParamArray {
                        let work = Work()
                            work.userName        = workParam["userName"] as? String
                            work.workIn          = workParam["workIn"] as? String
                            work.workOut         = workParam["workOut"] as? String
                            work.workInComment   = workParam["workInComment"] as? String
                            work.workOutComment  = workParam["workOutComment"] as? String

                        self.works.append(work)
                    }
                    self.tableView.reloadData()
                }
                // ロードが完了したので、falseに
                self.isInLoad = false
        }
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
        
        var workInString  : String? = work.workIn
        var workOutString : String? = work.workOut
        var workIn  = NSDate()
        var workOut = NSDate()
        
        let dateFormat = "yyyy年MM月dd日"
        
        if (workInString != nil) {
            workIn = NSDate.stringToDate(workInString!)
            workInString = NSDate.dateToString(workIn, nsFormat: dateFormat)
        }
        if (workOutString != nil) {
            workOut = NSDate.stringToDate(workOutString!)
            workOutString = NSDate.dateToString(workOut, nsFormat: dateFormat)
        }
        
        var cellText = workInString!
        if workInString != nil { cellText += "【出勤済】" }
        if workOutString != nil { cellText += "【退勤済】" }

        cell.textLabel!.text = cellText
        
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
            DetailVC.detailWorks = self.works[cellNum] as AnyObject as! Work
        }
    }
    
}
