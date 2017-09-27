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
    
    var str = [String]()
    @IBOutlet weak var launchTextView: UITextView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // textview setting
        launchTextView.layer.borderColor = UIColor.black.cgColor
        launchTextView.layer.borderWidth = 1.0
        launchTextView.isEditable = false
        launchTextView.clipsToBounds = true
        
        // 오늘의 점심 가져오기
        getTodayMealInfo(searchYear: 2017, searchMonth: 09, searchDay: 18) { (result) in
            print("result : \(result!)")
            self.launchTextView.text = result
        }
    }
    
    // 오늘의 점심 정보 가져오기
    func getTodayMealInfo(searchYear: Int, searchMonth: Int, searchDay: Int, completionHandler: @escaping (String?) -> Void){
        if let url = URL(string: "http://www.samil.hs.kr/main.php?menugrp=060603&master=meal2&act=list&SearchYear=2017&SearchMonth=09&SearchDay=18#diary_list"){
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

