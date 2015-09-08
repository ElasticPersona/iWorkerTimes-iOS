//
//  DetailTableViewController.swift
//  iWorkerTimes
//
//  Created by Shuhei Hasegawa on 2015/08/31.
//  Copyright (c) 2015年 Shuhei Hasegawa. All rights reserved.
//

import UIKit
import SwiftyJSON

class DetailTableViewController: UITableViewController {
    
    // 画面遷移時に渡されるセル情報
    var info = [String:AnyObject]()

    // Tableで使用する配列を定義する.
    private var myItems: NSArray?
    
    // Sectionで使用する配列を定義する.
    private let mySections: NSArray = ["ユーザ名", "出勤時刻", "退勤時刻", "備考"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
        //addRefreshControl()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    セクションの数を返す.
    */
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return mySections.count
    }
    
    /*
    セクションのタイトルを返す.
    */
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mySections[section] as? String
    }
    
    /*
    Cellが選択された際に呼び出される.
    */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    /*
    テーブルに表示する配列の総数を返す.
    */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    /*
    Cellに値を設定する.
    */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("datailTableCell", forIndexPath: indexPath) as! UITableViewCell
        
        if indexPath.section == 0 {
            cell.textLabel?.text = String(stringInterpolationSegment: info["userName"]!)
        } else if indexPath.section == 1 {
            cell.textLabel?.text = String(stringInterpolationSegment: info["workIn"]!)
        } else if indexPath.section == 2 {
            cell.textLabel?.text = String(stringInterpolationSegment: info["workOut"]!)
        } else if indexPath.section == 3 {
            cell.textLabel?.text = String(stringInterpolationSegment: info["comment"]!)
        }

        return cell
    }
    
    
    // プルダウンでリロード機能を付加
    func addRefreshControl() {
        var refresh = UIRefreshControl()
        // ロード時に表示される文字を設定
        //refresh.attributedTitle = NSAttributedString(string: "Now Loading...")
        // プルダウン時に呼び出されるメソッドを設定
        refresh.addTarget(self, action: "pullToRefresh", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refresh
    }
    
    
    // リロード時の処理
    func pullToRefresh() {
        self.tableView.reloadData()
    }
    
}

