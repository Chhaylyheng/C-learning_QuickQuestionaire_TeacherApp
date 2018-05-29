//
//  MaterialListTableViewController.swift
//  C Learning Teacher
//
//  Created by kit on 5/25/2561 BE.
//  Copyright © 2561 BE kit. All rights reserved.
//

import UIKit
import Alamofire

class MaterialListTableViewController: UITableViewController {
    
    var materials = [MaterialList]()
    var num = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        materialAPI()
        
        let nibName1 = UINib(nibName: "CategoryTableViewCell", bundle: nil)
        tableView.register(nibName1, forCellReuseIdentifier: "CategoryCell")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return num
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as? CategoryTableViewCell  else {
            fatalError("The dequeued cell is not an instance of CategoryTableViewCell.")
        }
        if materials.isEmpty {
            return cell
        } else {
            cell.CategoryNameLabel.text = materials[0].mes[indexPath.row].mcName
            cell.PublicLabel.text = "Public/All: \(materials[0].mes[indexPath.row].mcPubNum) / \(materials[0].mes[indexPath.row].mcNum)"
            if materials[0].mes[indexPath.row].mcLastDate == nil {
                cell.LastDateLabel.isHidden = true
            } else {
                cell.LastDateLabel.isHidden = false
                cell.LastDateLabel.text = "Date: \(materials[0].mes[indexPath.row].mcLastDate as! String)"
            }
            
            if materials[0].mes[indexPath.row].mcTotalSize == nil {
                cell.CapacityLabel.isHidden = true
            } else {
                cell.CapacityLabel.isHidden = false
                cell.CapacityLabel.text = "Capacity: \(materials[0].mes[indexPath.row].mcTotalSize as! String)"
            }
            if materials[0].mes[indexPath.row].mcPubNum.isEqual("1") {
                cell.pushImageView.image = UIImage(named: "circle")
            } else {
                cell.pushImageView.image = UIImage(named: "cancel")
            }
            
            cell.EditButton.tag = indexPath.row
            cell.DeleteButton.tag = indexPath.row
            
            return cell
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


// MARK: Request Data From API

extension MaterialListTableViewController {
    
    //MARK: Material List Data
    func materialAPI() {
        Alamofire.request("http://kit.c-learning.jp/t/ajax/material/cateList", method: .post, parameters: ["ctID": "c398223976"],encoding: URLEncoding.default, headers: nil).responseJSON {
            response in
            
            guard let data = response.data else {
                return
            }
            do {
                
                self.materials = try [JSONDecoder().decode(MaterialList.self, from: data)]
                self.num = self.materials[0].mes.count
                self.tableView.reloadData()
            } catch {
                print(error)
            }
            
        }
        
    }
}
