//
//  InputViewController.swift
//  taskapp
//
//  Created by Hilarion on 2016/05/26.
//  Copyright © 2016年 hidenori.nagasawa. All rights reserved.
//

import UIKit
import RealmSwift

class InputViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let realm = try! Realm()
    var task:Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 背景をタップしたらdismissKeyboardメソッドを呼ぶ
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(inputViewController?.dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        titleTextField.text = task.title
        contentsTextView.text = task.contents
        datePicker.date = task.date
    }
    
    override func viewWillDisappear(animated: Bool) {
        try! realm.write {
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date
            self.realm.add(self.task, update: true)
        }
        
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        // キーボードを閉じる
        view.endEditing(true)
    }
    
    // タスクのローカル通知を設定する
    func setNotifiction(task: Task){
        
        // すでに同じタスクが登録されていたらキャンセルする
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
            if notification.userInfo!["id"] as! Int == task.id {
                UIApplication.sharedApplication().cancelLocalNotification(notification)
                break
            }
        }
        
        let notification = UILocalNotification()
        
        notification.fireDate = task.date
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.alertBody = "\(task.title)"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["id": task.id]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
    }

}
