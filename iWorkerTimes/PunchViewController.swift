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

@IBDesignable class PunchViewController: UIViewController, UITextFieldDelegate {
    
    private let secondLayer = CAShapeLayer()
    private var punchCommentField: UITextField!
    
    var works = [[String:AnyObject]]()
    var customSlider = UISlider()
    var punchComment = ""
    let punchStatus = ["in": 0, "out": 1, "fin": 2]
    var nowStatus = 0
    
    // 打刻ボタンでリクエストを送るURL
    let urlPostString = "http://52.68.68.148:3000/work"
    // 今日の打刻状況を取得するURL
    let urlTodayString = "http://52.68.68.148:3000/work/today"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // CADisplayLink生成
        self.displayLinkCreate()
        
        // 現在時刻表示生成
        var timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("nowTimeViewCreate"), userInfo: nil, repeats: true);
        
        // 打刻ボタン生成
        self.punchSliderCreate()
        
        // 備考欄生成
        self.inputCommentCreate()
        
        // 今日の打刻状況を取得
        self.fetchTodayWorks()
        
        // スワイプ認識
        let pageSwipe = UISwipeGestureRecognizer(target: self, action: "swipeGesture:")
        pageSwipe.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(pageSwipe)
    }
    
    // 備考欄の生成
    func inputCommentCreate() {
        
        // UITextFieldを作成する.
        punchCommentField = UITextField(frame: CGRectMake(0,0,self.view.bounds.width,30))
        
        // 表示する文字を代入する.
        punchCommentField.text = ""
        punchCommentField.placeholder = "備考"
        
        // Delegateを設定する.
        punchCommentField.delegate = self
        
        // 枠を表示する.
        punchCommentField.borderStyle = UITextBorderStyle.RoundedRect
        
        // UITextFieldの表示する位置を設定する.
        punchCommentField.layer.position = CGPoint(x:self.view.bounds.width/2, y:self.view.bounds.height/1.05);
        
        // Viewに追加する.
        self.view.addSubview(punchCommentField)
        
    }
    
    /*
    UITextFieldが編集された直後に呼ばれるデリゲートメソッド.
    */
    func textFieldDidBeginEditing(textField: UITextField){
        self.punchComment = textField.text
    }
    
    /*
    UITextFieldが編集終了する直前に呼ばれるデリゲートメソッド.
    */
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        self.punchComment = textField.text
        
        return true
    }
    
    /*
    改行ボタンが押された際に呼ばれるデリゲートメソッド.
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.punchComment = textField.text
        
        return true
    }
    
    
    
    // CADisplayLink生成
    func displayLinkCreate() {
        
        // 円のレイヤー
        let frame = view.frame
        let path = UIBezierPath()
        path.addArcWithCenter(
            CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame)),
            radius: frame.width / 2.0 - 20.0,
            startAngle: CGFloat(-M_PI_2),
            endAngle: CGFloat(M_PI + M_PI_2),
            clockwise: true)
        secondLayer.path = path.CGPath
        secondLayer.strokeColor = UIColor.blackColor().CGColor
        secondLayer.fillColor = UIColor.clearColor().CGColor
        secondLayer.speed = 0.0     // ※1
        view.layer.addSublayer(secondLayer)
        
        // 円を描くアニメーション
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 60.0
        secondLayer.addAnimation(animation, forKey: "strokeCircle")
        
        // CADisplayLink設定
        let displayLink = CADisplayLink(target: self, selector: Selector("update:"))
        displayLink.frameInterval = 1   // ※2
        displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        
    }
    func update(displayLink: CADisplayLink) {
        // timeOffsetに現在時刻の秒数を設定
        let time = NSDate().timeIntervalSince1970
        let seconds = floor(time) % 60
        let milliseconds = time - floor(time)
        secondLayer.timeOffset = seconds + milliseconds   // ※3
    }
    
    // 現在時刻表示
    func nowTimeViewCreate() {
        
        //現在時刻を取得.
        let myDate: NSDate = NSDate()
        
        //カレンダーを取得.
        let myCalendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        
        //取得するコンポーネントを決める.
        let myComponetns = myCalendar.components(NSCalendarUnit.CalendarUnitYear   |
            NSCalendarUnit.CalendarUnitMonth  |
            NSCalendarUnit.CalendarUnitDay    |
            NSCalendarUnit.CalendarUnitHour   |
            NSCalendarUnit.CalendarUnitMinute |
            NSCalendarUnit.CalendarUnitSecond |
            NSCalendarUnit.CalendarUnitWeekday,
            fromDate: myDate)
        
        let weekdayStrings: Array = ["nil","日","月","火","水","木","金","土","日"]
        
        /*
        println("year: \(myComponetns.year)")
        println("month: \(myComponetns.month)")
        println("day: \(myComponetns.day)")
        println("hour: \(myComponetns.hour)")
        println("minute: \(myComponetns.minute)")
        println("second: \(myComponetns.second)")
        println("weekday: \(weekdayStrings[myComponetns.weekday])")
        */
        
        //現在時間表示用のラベルを生成.
        var timeLabel: UILabel = UILabel()
        timeLabel.font = UIFont(name: "HiraKakuInterface-W1", size:UIFont.labelFontSize())
        
        var myStr: String = "\(myComponetns.year)年"
        myStr += "\(myComponetns.month)月"
        myStr += "\(myComponetns.day)日["
        myStr += "\(weekdayStrings[myComponetns.weekday])]"
        myStr += "\(myComponetns.hour)時"
        myStr += "\(myComponetns.minute)分"
        myStr += "\(myComponetns.second)秒"
        
        timeLabel.text = myStr
        timeLabel.frame = CGRect(x: 0, y: self.view.bounds.height/2, width: self.view.bounds.width, height: 20)
        timeLabel.textAlignment = NSTextAlignment.Center
        
        self.view.viewWithTag(1)?.removeFromSuperview()
        
        timeLabel.tag = 1
        self.view.addSubview(timeLabel)
    }
    
    // 打刻カスタムスライダー生成
    func punchSliderCreate() {
        
        //枠画像(14×50)の取得
        var minImage = UIImage(named: "sliderL2.png")
        var maxImage = UIImage(named: "sliderR2.png")
        
        //ツマミ画像(50×50 余白を左右に10px加えたもの)
        //var tumbImage = UIImage(named: "punchInSlider.jpg")
        //tumbImage?.resizableImageWithCapInsets(UIEdgeInsetsMake(100.0, 50.0, 100.0, 50.0))
        
        //左右枠画像の伸張設定
        let minInsets : UIEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0)
        minImage = minImage!.resizableImageWithCapInsets(minInsets)
        let maxInsets : UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8)
        maxImage = maxImage!.resizableImageWithCapInsets(maxInsets)
        
        //スライダーインスタンス生成
        customSlider = UISlider(frame: CGRectMake(0, self.view.frame.height/1.3, self.view.frame.width, 100))
        
        //枠画像をスライダーへ登録（登録した時点で、スライダーのviewのwidthに合うように枠画像が伸張する模様）
        customSlider.setMinimumTrackImage(minImage, forState: .Normal)
        customSlider.setMaximumTrackImage(maxImage, forState: .Normal)
        
        //ツマミ画像をスライダーへ登録
        //customSlider.setThumbImage(tumbImage, forState: .Normal)
        
        //各種値設定
        customSlider.minimumValue = 0.0
        customSlider.maximumValue = 100.0
        customSlider.continuous = true
        
        //スライダー初期値
        customSlider.value = 3.0
        
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
        self.customSlider.value = 3.0
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
    
    // 打刻処理
    func toPunch() {
        
        let alert = UIAlertView()
        
        if self.nowStatus != punchStatus["fin"]! {
            
            // ユーザ名を付加させてリクエストを送る
            let defaults = NSUserDefaults.standardUserDefaults()
            let userName = defaults.stringForKey("userName")
            let comment = self.punchComment
            let params = [
                "userName" : userName!,
                "comment" : comment
            ]
        
            request(.POST, urlPostString, parameters: params, encoding: .JSON)
                .responseJSON {
                    (request, response, data, error) -> Void in
                
            }
            
            // 打刻後に出すメッセージを作成
            alert.title = "打刻しました。"
            alert.message = NSDate.dateToString(NSDate(), nsFormat: "yyyy年MM月dd日 HH時mm分") + comment
            self.punchComment = ""
            
        } else {
            
            alert.title = "本日は打刻済みです。お疲れ様でした。"
            alert.message = NSDate.dateToString(NSDate(), nsFormat: "yyyy年MM月dd日 HH時mm分")
            self.punchComment = ""
            
        }
        
        alert.addButtonWithTitle("OK")
        alert.show()
        
        loadView()
        viewDidLoad()
        
    }
    
    // 今日の打刻状況を取得
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
                    let results = JSON(resJson!)
                    let data = results["results"][0]
                    var workIn = data["workIn"]
                    var workOut = data["workOut"]
                    
                    //今日の打刻チェック
                    if (workIn == nil && workOut == nil) {
                        //出社打刻（イメージ変更）
                        self.nowStatus = self.punchStatus["in"]!
                        var punchInImage = UIImage(named: "punchInSlider.jpg")
                        self.customSlider.setThumbImage(punchInImage, forState: .Normal)
                        
                    } else if (workIn != nil && workOut == nil) {
                        //退勤打刻（イメージ変更）
                        self.nowStatus = self.punchStatus["out"]!
                        var punchOutImage = UIImage(named: "punchOutSlider.jpg")
                        self.customSlider.setThumbImage(punchOutImage, forState: .Normal)
                        
                    } else {
                        //打刻ボタン操作不可（イメージ変更）
                        self.nowStatus = self.punchStatus["fin"]!
                        var punchFinImage = UIImage(named: "punchFinSlider.jpg")
                        self.customSlider.setThumbImage(punchFinImage, forState: .Normal)
                    }
                    
                }
        }
        
    }

}

