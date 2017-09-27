//
//  ViewController.swift
//  EatLaunch
//
//  Created by 최혜선 on 2017. 9. 26..
//  Copyright © 2017년 최혜선. All rights reserved.
//

import UIKit
import Fuzi

class ViewController: UIViewController {
    
    @IBOutlet weak var launchTextView: UITextView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var openDatePickerButton: UIButton!
    
    var searchDate: String = ""
    
    // datepicker 날짜 변경에 따라 '날짜 선택' 버튼 텍스트 변경
    @IBAction func changeDatePicker(_ sender: Any) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd"
        let date = dateformatter.string(from: (sender as! UIDatePicker).date)
        openDatePickerButton.setTitle(date, for: UIControlState())
        
        // 날짜 가져와서 파라미터로 넘기기
        let search = date.components(separatedBy: "-")
        
        // 오늘의 점심 가져오기
        getTodayMealInfo(searchYear: search[0], searchMonth: search[1], searchDay: search[2]) { (result) in
            self.activityIndicatorView.stopAnimating()
            self.launchTextView.text = result
        }
    }
    
    // 날짜 선택 버튼 액션
    @IBAction func openDatePickerButton(_ sender: Any) {
        if datePicker.isHidden == true{
            datePicker.isHidden = false
        }else{
            datePicker.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // textview setting
        launchTextView.layer.borderColor = UIColor.black.cgColor
        launchTextView.layer.borderWidth = 1.0
        launchTextView.isEditable = false
        launchTextView.clipsToBounds = true
        
        // 날짜 선택 버튼
        openDatePickerButton.layer.borderColor = UIColor.gray.cgColor
        openDatePickerButton.layer.borderWidth = 1.0
        openDatePickerButton.layer.cornerRadius = 2.0
        openDatePickerButton.clipsToBounds = true
        
        // date picker
        datePicker.isHidden = true
        
        activityIndicatorView.hidesWhenStopped = true
        
        
        let date = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd"
        let result = dateformatter.string(from: date)
        openDatePickerButton.setTitle(result, for: UIControlState())
        let search = result.components(separatedBy: "-")
        
        // 앱 실행 시 오늘 날짜 급식 정보 가져오기
        getTodayMealInfo(searchYear: search[0], searchMonth: search[1], searchDay: search[2]) { (result) in
            self.launchTextView.text = result
        }
    }
    
    
    // 오늘의 점심 정보 가져오기
    func getTodayMealInfo(searchYear: String, searchMonth: String, searchDay: String, completionHandler: @escaping (String?) -> Void){
        
        var str = [String]()
        
        // http://www.samil.hs.kr/main.php?menugrp=060603&master=meal2&act=list&SearchYear=2017&SearchMonth=09&SearchDay=18#diary_list
        let BASE_URL = "http://www.samil.hs.kr/main.php?menugrp=060603&master=meal2&act=list"
        
        let SEARCH_URL = "\(BASE_URL)&SearchYear=\(searchYear)&SearchMonth=\(searchMonth)&SearchDay=\(searchDay)#diary_list"
        
        if let url = URL(string: SEARCH_URL){
            do{
                let contents = try NSString(contentsOf: url, usedEncoding: nil)
                //                print(contents)   // 전체 HTML 소스
                
                let doc = try HTMLDocument(string: contents as String, encoding: String.Encoding.utf8)
                
                // XPath queries
                if let firstAnchor = doc.firstChild(xpath: "//div") {
                    for script in firstAnchor.xpath("//td"){
                        str.append(script.stringValue.trimmingCharacters(in: .whitespacesAndNewlines))
                    }
                    // 완료되면 급식 정보 리턴
                    completionHandler(str[str.count-1])
                }
                
                // for문에서 script 값 마지막에 급식 정보 나와서 배열에 저장한 후 마지막 인덱스를 가져온다
                print(str[str.count-1])
                
            }catch let error{
                // contents could not be loaded
                print(error)
            }
        }else{
            // the URL was bad!
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

