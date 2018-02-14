//
//  DetailViewController.swift
//  PNChartSwift
//
//  Created by YiChen Zhou on 8/14/17.
//

import UIKit
import Alamofire


class DetailViewController: UIViewController {
    var chartName: String?

    var numArray : NSArray = []
    var perArray : NSArray = []
    var yesNum : Int = 0
    var yesPer : Int = 0
    var noNum  : Int = 0
    var noPer : Int = 0
    
    @IBOutlet weak var noanwserYet: UILabel!
    @IBOutlet weak var qbTitles: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        qbTitles.text = qbTitle
        self.title = "Total Result"
        if qbID == "" {
            self.noanwserYet.text = "No answer yet!"
        } else {
            getAwnserFromStudent()
        }
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
    
    
    private func setPieChart() -> PNPieChart {
        let yesString = "\(yesNum)"
        let noString = "\(noNum)"
        let item1 = PNPieChartDataItem(dateValue: CGFloat(yesPer), dateColor:  PNLightGreen, description: "Yes"+","+yesString)
        let item2 = PNPieChartDataItem(dateValue: CGFloat(noPer), dateColor: PNRed, description: "No"+","+noString)
        let frame = CGRect(x: 40, y: 155, width: 240, height: 240)
        let items: [PNPieChartDataItem] = [item1, item2]
        let pieChart = PNPieChart(frame: frame, items: items)
        pieChart.descriptionTextColor = UIColor.white
        pieChart.descriptionTextFont = UIFont(name: "Avenir-Medium", size: 14)!
        pieChart.center = self.view.center
        return pieChart
    }
    
    
//    @IBAction func cancleBtn(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "Main")
//        self.present(controller, animated: true, completion: nil)
//    }
    
    
    
//    private func setBarChart() -> PNBarChart {
//        let barChart = PNBarChart(frame: CGRect(x: 0, y: 135, width: 320, height: 200))
//        barChart.backgroundColor = UIColor.clear
//        barChart.animationType = .Waterfall
//        barChart.labelMarginTop = 5.0
//        barChart.xLabels = ["Sep 1", "Sep 2", "Sep 3", "Sep 4", "Sep 5", "Sep 6", "Sep 7"]
//        barChart.yValues = [1, 23, 12, 18, 30, 12, 21]
//        barChart.strokeChart()
//        barChart.center = self.view.center
//        return barChart
//    }
//
//    private func setLineChart() -> PNLineChart {
//        let lineChart = PNLineChart(frame: CGRect(x: 0, y: 135, width: 320, height: 250))
//        lineChart.yLabelFormat = "%1.1f"
//        lineChart.showLabel = true
//        lineChart.backgroundColor = UIColor.clear
//        lineChart.xLabels = ["Sep 1", "Sep 2", "Sep 3", "Sep 4", "Sep 5", "Sep 6", "Sep 7"]
//        lineChart.showCoordinateAxis = true
//        lineChart.center = self.view.center
//
//        let dataArr = [60.1, 160.1, 126.4, 232.2, 186.2, 127.2, 176.2]
//        let data = PNLineChartData()
//        data.color = PNGreen
//        data.itemCount = dataArr.count
//        data.inflexPointStyle = .None
//        data.getData = ({
//            (index: Int) -> PNLineChartDataItem in
//            let yValue = CGFloat(dataArr[index])
//            let item = PNLineChartDataItem(y: yValue)
//            return item
//        })
//
//        lineChart.chartData = [data]
//        lineChart.strokeChart()
//        return lineChart
//    }
    
    func getAwnserFromStudent() {
        
        Alamofire.request("https://kit.c-learning.jp/t/ajax/quest/Bent", method: .post, parameters: ["qb":qbID ,"com": "0","mode":"ALL",], encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if let dictionary = response.result.value as? [String: Any] {
                    
                      print (dictionary)
                    let res = dictionary["res"] as! NSDictionary
                    
                    if let bent = res["bent"] as? NSDictionary {
                        let all = bent["ALL"] as? NSArray
                        self.numArray = (all?.value(forKey: "num")  as! NSArray)
                        self.perArray = (all?.value(forKey: "per") as! NSArray)
                        self.yesNum = self.numArray[1] as! Int
                        self.noNum = self.numArray[2] as! Int
                        self.yesPer = Int(self.perArray[1] as! Float)
                        self.noPer = Int(self.perArray[2] as! Float)
                        if self.yesNum != 0 || self.noNum != 0 {
                            let pieChart = self.setPieChart()
                            self.view.addSubview(pieChart)
                            self.noanwserYet.isHidden = true
                            
                        } else {
                            self.noanwserYet.text = "No answer yet!"
                        }
                        
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

