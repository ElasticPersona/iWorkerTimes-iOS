//
//  SettingTableViewController.swift
//  iWorkerTimes
//
//  Created by Shuhei Hasegawa on 2015/09/04.
//  Copyright (c) 2015年 Shuhei Hasegawa. All rights reserved.
//

import UIKit
import Photos

class SettingTableViewController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    private let settingSections: NSArray = ["登録情報", "背景設定", "出勤打刻通知タイミング", "退勤打刻通知タイミング"]
    
    private var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    /*
    セクションの数を返す.
    */
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return settingSections.count
    }
    
    /*
    セクションのタイトルを返す.
    */
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingSections[section] as? String
    }
    
    /*
    Cellが選択された際に呼び出される.
    */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.imageSelectController()
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("settingTableCell", forIndexPath: indexPath) 
        
        if indexPath.section == 0 {
            
            // UITextFieldを作成する.
            nameTextField = UITextField(frame: CGRectMake(0,0,200,30))
            
            // 保存されているユーザ名を代入する.
            let defaults = NSUserDefaults.standardUserDefaults()
            let userName = defaults.stringForKey("userName")
            nameTextField.text = userName
            
            // 枠を表示する.
            nameTextField.borderStyle = UITextBorderStyle.RoundedRect
            
            // UITextFieldの表示する位置を設定する.
            nameTextField.layer.position = CGPoint(x:self.view.bounds.width/2,y:100);
            
            // Viewに追加する.
            // self.view.addSubview(nameTextField)
            cell.accessoryView = nameTextField
            cell.textLabel?.text = "名前"
            
        } else if indexPath.section == 1 {
            
            cell.textLabel?.text = "背景を設定する"
            
        } else if indexPath.section == 2 {
            
            cell.textLabel?.text = "9:00"
            
        } else if indexPath.section == 3 {
            
            cell.textLabel?.text = "17:30"
            
        }
        
        return cell
    }
    
    
    // UINavigationControllerで戻った際に呼び出される
    override func viewDidDisappear(animated: Bool) {
        
        //入力されたユーザ名を取得
        let userName = self.nameTextField.text
        
        // NSDefaultsに保存する
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(userName , forKey: "userName")
        print(defaults.objectForKey("userName"), terminator: "")
        
        // すぐにデータを永続化させる
        let success = defaults.synchronize()
        if success {
            print("データを同期しました", terminator: "")
        }
        
    }
    
    
    /*
    UITextFieldが編集された直後に呼ばれるデリゲートメソッド.

    func textFieldDidBeginEditing(textField: UITextField){
        println("textFieldDidBeginEditing:" + textField.text)
    }
    */
    /*
    UITextFieldが編集終了する直前に呼ばれるデリゲートメソッド.

    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        println("textFieldShouldEndEditing:" + textField.text)
        
        return true
    }
    */
    /*
    改行ボタンが押された際に呼ばれるデリゲートメソッド.

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    
    /*
     * 背景選択
     */
    func imageSelectController() {
        
        let actionSheet = UIAlertController(title:"Image", message: "Select the image", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {action in
            //nothing
        })
        let actionNormal1 = UIAlertAction(title: "From Album", style: UIAlertActionStyle.Default, handler: {action in
            let imagePickerVc = UIImagePickerController()
            imagePickerVc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePickerVc.delegate = self
            self.presentViewController(imagePickerVc, animated: true, completion: nil)
        })
        let actionNormal2 = UIAlertAction(title: "From Camera", style: UIAlertActionStyle.Default, handler: {action in
            let imagePickerVc = UIImagePickerController()
            imagePickerVc.sourceType = UIImagePickerControllerSourceType.Camera
            imagePickerVc.delegate = self
            self.presentViewController(imagePickerVc, animated: true, completion: nil)
        })
        actionSheet.addAction(actionCancel)
        actionSheet.addAction(actionNormal1)
        actionSheet.addAction(actionNormal2)
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    /*
     * 画像選択後に呼ばれるメソッド
     */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.dismissViewControllerAnimated(true, completion: nil)

        // from camaera
        if (info.indexForKey(UIImagePickerControllerOriginalImage) != nil) {
            let tookImage: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            // デバイスのDocumentsディレクトリのパスを取得
            var documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
            documentsPath = (documentsPath as NSString).stringByAppendingPathComponent("top.png")
            //var imagePath = NSHomeDirectory()
            //imagePath = (imagePath as NSString).stringByAppendingPathComponent("Documents/top.png")
            var imageData: NSData = UIImagePNGRepresentation(tookImage)!
            let isSuccess = imageData.writeToFile(documentsPath, atomically: true)
            if isSuccess {
                let fileUrl: NSURL = NSURL(fileURLWithPath: documentsPath)
                print(fileUrl, terminator: "")
                //uploadToS3(fileUrl)
            }
            return
        }
        
        // from album
        var pickedURL:NSURL = info[UIImagePickerControllerReferenceURL] as! NSURL
        let fetchResult: PHFetchResult = PHAsset.fetchAssetsWithALAssetURLs([pickedURL], options: nil)
        let asset: PHAsset = fetchResult.firstObject as! PHAsset
        
        PHImageManager.defaultManager().requestImageDataForAsset(asset, options: nil, resultHandler: {(imageData: NSData?, dataUTI: String?, orientation: UIImageOrientation, info: [NSObject : AnyObject]?) in
            let fileUrl: NSURL = info as! NSURL
            print(fileUrl, terminator: "")
            //self.uploadToS3(fileUrl)
        })
    }

}
