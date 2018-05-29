//
//  BarChartThreeViewController.swift
//  C Learning Teacher
//
//  Created by KEEN on 2/14/18.
//  Copyright © 2018 kit. All rights reserved.
//

import UIKit
import Alamofire

class BarChartThreeViewController: UIViewController {

    var numArray : NSArray = []
    var perArray : NSArray = []
    var Cone : Int = 0
    var ConePer : Int = 0
    var Ctwo : Int = 0
    var CtwoPer : Int = 0
    var Cthree : Int = 0
    var CthreePer : Int = 0
    
    @IBOutlet weak var noanwserYet: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Total Result"
        setUpNavBar()
        if qbID == "" {
            self.noanwserYet.text = "No answer yet!"
        } else {
            getAwnserFromStudent()
        }
        //        let pieChart = self.setBarChart()
        //        self.view.addSubview(pieChart)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setBarChart() -> PNBarChart {
        let barChart = PNBarChart(frame: CGRect(x: 0, y: 135, width: 320, height: 200))
        barChart.backgroundColor = UIColor.clear
        barChart.animationType = .Waterfall
        barChart.labelMarginTop = 5.0
        barChart.xLabels = ["1", "2", "3"]
        barChart.yValues = [CGFloat(ConePer), CGFloat(CtwoPer), CGFloat(CthreePer)]
        barChart.strokeChart()
        barChart.center = self.view.center
        return barChart
    }
    
    func setUpNavBar(){
        //For title in navigation bar
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.view.tintColor = UIColor.orange
        self.navigationItem.title = "Total Result"
        
        //For back button in navigation bar
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    func getAwnserFromStudent() {
        
        Alamofire.request("https://kit.c-learning.jp/t/ajax/quest/Bent", method: .post, parameters: ["qb":qbID ,"com": "0","mode":"ALL",], encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                print (response.result.value ?? "why")
                if let dictionary = response.result.value as? [String: Any] {
                    let res = dictionary["res"] as! NSDictionary
                    let bent = res["bent"] as? NSDictionary
                    let all = bent!["ALL"] as? NSArray
                    self.numArray = (all?.value(forKey: "num")  as! NSArray)
                    self.perArray = (all?.value(forKey: "per") as! NSArray)
                    for i in 1...self.numArray.count - 1 {
                        switch i {
                        case 1 :
                            self.Cone = self.numArray[1] as! Int
                            self.ConePer = self.perArray[1] as! Int
                            break
                        case 2 :
                            self.Ctwo = self.numArray[2] as! Int
                            self.CtwoPer = self.perArray[2] as! Int
                            break
                        case 3:
                            self.Cthree = self.numArray[3] as! Int
                            self.CthreePer = self.perArray[3] as! Int
                            break
                            
                        default:
                            break
                        }
                    }
                    if self.Cone != 0 || self.Ctwo != 0 || self.Cthree != 0 {
                        let barChart = self.setBarChart()
                        self.view.addSubview(barChart)
                        // self.noanwserYet.isHidden = true
                        
                    } else {
                        // self.noanwserYet.text = "No answer yet!"
                    }
                    
                }
                break
                
            case .failure(_):
                print(response.result.error ?? "hek")
                break
                
            }
        }
        
    }


}
