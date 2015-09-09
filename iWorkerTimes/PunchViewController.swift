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

@IBDesignable class PunchViewController: UIViewController {
    
    var works = [[String:AnyObject]]()
    var customSlider = UISlider()
    
    // 打刻ボタンでリクエストを送るURL
    let urlPostString = "http://52.68.68.148:3000/work"
    // 今日の打刻状況を取得するURL
    let urlTodayString = "http://52.68.68.148:3000/work/today"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 今日の打刻状況を取得する
        self.fetchTodayWorks()
        
        // 打刻ボタン作成
        self.punchSliderCreate()
        
        // スワイプ認識.
        let pageSwipe = UISwipeGestureRecognizer(target: self, action: "swipeGesture:")
        pageSwipe.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(pageSwipe)
    }
    
    func punchSliderCreate() {
        
        //枠画像(14×50)の取得
        var minImage = UIImage(named: "sliderL.png")
        var maxImage = UIImage(named: "sliderR.png")
        
        //ツマミ画像(50×50 余白を左右に10px加えたもの)
        var tumbImage = UIImage(named: "punchSlider.jpg")
        //tumbImage?.resizableImageWithCapInsets(UIEdgeInsetsMake(100.0, 50.0, 100.0, 50.0))
        
        //左右枠画像の伸張設定
        minImage?.stretchableImageWithLeftCapWidth(6, topCapHeight: 0)
        maxImage?.stretchableImageWithLeftCapWidth(6, topCapHeight: 0)
        
        //スライダーインスタンス生成
        customSlider = UISlider(frame: CGRectMake(0, self.view.frame.height-100, self.view.frame.width, 100))
        
        //枠画像をスライダーへ登録（登録した時点で、スライダーのviewのwidthに合うように枠画像が伸張する模様）
        customSlider.setMinimumTrackImage(minImage, forState: .Normal)
        customSlider.setMaximumTrackImage(maxImage, forState: .Normal)
        
        //ツマミ画像をスライダーへ登録
        customSlider.setThumbImage(tumbImage, forState: .Normal)
        
        //各種値設定
        customSlider.minimumValue = 0.0
        customSlider.maximumValue = 100.0
        customSlider.continuous = true
        
        //スライダー初期値
        customSlider.value = 0.0
        
        //値の変化時のアクション
        customSlider.addTarget(self, action: "punchSlider:", forControlEvents: UIControlEvents.ValueChanged)
        
        //指を付けた時のアクション
        customSlider.addTarget(self, action: "punchSliderStart:", forControlEvents: UIControlEvents.TouchDown)
        
        //指を離した時のアクション
        customSlider.addTarget(self, action: "punchSliderStop:", forControlEvents: (UIControlEvents.TouchUpInside | UIControlEvents.TouchUpOutside | UIControlEvents.TouchCancel))
        
        
        //カスタムスライダーをViewへ登録
        self.view!.addSubview(customSlider)
    }
    
    func punchSlider(slider: UISlider) {
        // Do something with the value...
        println("Value changed \(slider.value)")
        
        //スライダーを右端まで動かした場合打刻する
        if (slider.value == 100.0) {
            self.toPunch()
        }
    }
    
    func punchSliderStart(slider: UISlider) {
        println("このまま打刻")
    }
    
    func punchSliderStop(slider: UISlider) {
        println("離したね")
        self.customSlider.value = 0.0
    }
    
    /*
    カスタムスライダー
    */
    /*
    @IBInspectable var startColor:UIColor = UIColor.redColor()
    @IBInspectable var endColor:UIColor = UIColor.blueColor()
    
    #if TARGET_INTERFACE_BUILDER
    override func willMoveToSuperview(newSuperview: UIView?) {
    
    let slider:BWCircularSlider = BWCircularSlider(startColor:self.startColor, endColor:self.endColor, frame: self.bounds)
    self.addSubview(slider)
    
    }
    
    #else
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        // Build the slider
        let slider:BWCircularSlider = BWCircularSlider(startColor:self.startColor, endColor:self.endColor, frame: self.view!.bounds)
        
        // Attach an Action and a Target to the slider
        slider.addTarget(self, action: "valueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        // Add the slider as subview of this view
        self.view.addSubview(slider)
        
    }
    #endif
    
    func valueChanged(slider:BWCircularSlider){
        // Do something with the value...
        println("Value changed \(slider.angle)")
    }
    */
    
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
        self.toPunch()
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
    
    func toPunch() {
        
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
    
    func fetchTodayWorks() {
        
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
                    var workIn = data["results"][0]["workIn"]
                    var workOut = data["results"][0]["workOut"]
                    
                    //今日の打刻チェック
                    if (workIn == nil && workOut == nil) {
                        //出社打刻
                        println("出社打刻タイミング")
                    } else if (workIn != nil && workOut == nil) {
                        //退勤打刻
                        println("退勤打刻タイミング")
                    } else {
                        //打刻ボタン操作不可処理
                        println("打刻操作不可タイミング")
                    }
                    
                    //打刻ボタンイメージの変更
                    let image = UIImage(named: "punchOut")!
                    let imageButton = UIButton()
                    imageButton.setImage(image, forState: .Normal)
                    
                }
        }
        
    }

}

