//
//  CommentThreadViewController.swift
//  C Learning Teacher
//
//  Created by kit on 3/27/2561 BE.
//  Copyright © 2561 BE kit. All rights reserved.
//

import UIKit

class CommentThreadViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: ThreadHeaderView!
    
    // profile Image
    var userName : String = ""
    var postDate : String = ""
    var threadTitle: String = ""
    var threadBody: String = ""
    var postImageName: String = ""
    var commentNum: String = ""
    var seenNum : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configuation for Table View
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        
        // Configure header view
        headerViewSetup()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    public func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
        
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell
        
        cell.selectionStyle = .none
        return cell
    }
    
    func headerViewSetup() {
        //headerView.profileImage.image
        headerView.nameLabel.text = userName
        headerView.postDate.text = postDate
        headerView.titleLabel.text = threadTitle
        headerView.commentLable.text = threadBody
        //headerView.postImage.image =
        //headerView.commentNum.setTitle(<#T##title: String?##String?#>, for: .normal)
        headerView.seenNum.setTitle(seenNum, for: .normal)
        
        /* https://kit.c-learning.jp/getfile/s3file/imageName */
        if postImageName.isEmpty {
            //print("couldn't found the image")
            headerView.postImage?.image = nil
            headerView.postImage.isHidden = true
            
        } else if (!postImageName.isEqual("")){
            let urlstring = "https://kit.c-learning.jp/getfile/s3file/\(postImageName)"
            let ImageURL = NSURL(string: urlstring)
            let request = URLRequest(url: ImageURL! as URL)
            let networkProcessor = NetworkProcessing(request: request)
            networkProcessor.downloadData(completion: {(imageData, httpResponse, error) in
                DispatchQueue.main.async {
                    if let imageData = imageData {
                        self.headerView.postImage.image = UIImage(data: imageData)
                        //self.headerView.postImage.roundedCorners()
                    }
                }
            })
            
        }

    }
    

}
