//
//  QuestionwithcmdViewController.swift
//  C Learning Teacher
//
//  Created by KEEN on 2/10/18.
//  Copyright © 2018 kit. All rights reserved.
//

import UIKit
import Alamofire

class QuestionwithcmdViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var QuestioncmdCollection: UICollectionView!
    var numArray : NSArray = []
    var perArray : NSArray = []
    var comment_data : NSArray = []
    var yesNum : Int = 0
    var yesPer : Int = 0
    var noNum  : Int = 0
    var noPer : Int = 0
    var cPosted : Array = [""]
    var text : Array = [""]
    var cName : Array = [""]
    
    var alert = SweetAlert()
    
    @IBOutlet weak var noanwserYet: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        QuestioncmdCollection.delegate = self
        QuestioncmdCollection.dataSource = self
        
        if qbID == "" {
            self.noanwserYet.text = "No answer yet!"
        } else {
            getAwnserFromStudent()
        }


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return cPosted.count - 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : QuestioncmdCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestioncmdCell", for: indexPath) as! QuestioncmdCollectionViewCell
        cell.cmd.text = cPosted[indexPath.row+1]
        cell.name.text = text[indexPath.row+1]
        cell.cName.text = cName[indexPath.row+1]
        return cell
    }
    private func setPieChart() -> PNPieChart {
        let yesString = "\(yesNum)"
        let noString = "\(noNum)"
        let item1 = PNPieChartDataItem(dateValue: CGFloat(yesPer), dateColor:  PNLightGreen, description: "Yes"+","+yesString)
        let item2 = PNPieChartDataItem(dateValue: CGFloat(noPer), dateColor: PNFreshGreen, description: "No"+","+noString)
        let frame = CGRect(x: 40, y: 155, width: 240, height: 240)
        let items: [PNPieChartDataItem] = [item1, item2]
        let pieChart = PNPieChart(frame: frame, items: items)
        pieChart.descriptionTextColor = UIColor.white
        pieChart.descriptionTextFont = UIFont(name: "Avenir-Medium", size: 14)!
        pieChart.center = self.view.center
        return pieChart
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
        
        print(qbID)
        Alamofire.request("https://kit.c-learning.jp/t/ajax/quest/Bent", method: .post, parameters: ["qb":qbID ,"com": "1","mode":"ALL",], encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                print (response.result)
                if let dictionary = response.result.value as? [String: Any] {
                    let res = dictionary["res"] as! NSDictionary
                    let bent = res["bent"] as? NSDictionary
                    let bnet_all = bent!["ALL"] as? NSArray
                    self.numArray = (bnet_all?.value(forKey: "num")  as! NSArray)
                    self.perArray = (bnet_all?.value(forKey: "per") as! NSArray)
                    self.yesNum = self.numArray[1] as! Int
                    self.noNum = self.numArray[2] as! Int
                    self.yesPer = self.perArray[1] as! Int
                    self.noPer = self.perArray[2] as! Int
                    if let comment = res["comment"] as? NSDictionary{
                        if let commet_all = comment["ALL"] as? NSDictionary {
                            for id_comment in commet_all{
                                let data = id_comment.value as! NSDictionary
                                self.cPosted.append(data["cPosted"] as! String)
                                self.text.append(data["text"] as! String)
                                self.cName.append(data["cName"] as! String)
                                self.QuestioncmdCollection.isHidden = false
                                
                            }
                            
                        }
                        
                    } else {
                        self.QuestioncmdCollection.isHidden = true
                    }
                    
    
                    if self.yesNum != 0 || self.noNum != 0 {
                        let pieChart = self.setPieChart()
                        self.view.addSubview(pieChart)
                        self.noanwserYet.isHidden = true
                        
                    } else {
                        self.noanwserYet.text = "No answer yet!"
                    }
                }
                self.QuestioncmdCollection.reloadData()
                break
                
            case .failure(_):
                self.alert.showAlert("Error", subTitle: "Your question have not updated, because some problem", style: .error)
                break
                
            }
        }
        
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
