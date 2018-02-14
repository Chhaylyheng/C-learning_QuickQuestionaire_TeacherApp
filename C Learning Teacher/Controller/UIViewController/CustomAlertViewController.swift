
import UIKit
import Alamofire

class CustomAlertViewController : UIViewController {
    let transitioner = CAVTransitioner()
    @IBOutlet weak var yesNo: UIButton!
    @IBOutlet weak var yesNoCo: UIButton!
    @IBOutlet weak var AG: UIButton!
    @IBOutlet weak var AGCo: UIButton!
    @IBOutlet weak var TwoC: UIButton!
    @IBOutlet weak var TwoCC: UIButton!
    @IBOutlet weak var ThreeC: UIButton!
    @IBOutlet weak var ThreeCC: UIButton!
    @IBOutlet weak var FourC: UIButton!
    @IBOutlet weak var FourCC: UIButton!
    @IBOutlet weak var FiveC: UIButton!
    @IBOutlet weak var FiveCC: UIButton!
    @IBOutlet weak var Comment: UIButton!
    
    var alert = SweetAlert()
        let Mode : Array = ["Yes/No","Yes/No*","Agree/Disagree","Agree/Disagree*","Two Choice","Two Choice*","Three Choices","Three Choices*","Four Choices","Four Choices*","Five Choices","Five Choice*","Comment"]
        let ModeIndex : Array = [22,23,24,25,20,21,30,31,40,41,50,51,1]
    
    
    // Override function
    override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self.transitioner
    }
    
    convenience init() {
        self.init(nibName:nil, bundle:nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
   
}


//APP API

extension CustomAlertViewController {
    func createQuestion() {
        Alamofire.request("https://kit.c-learning.jp/t/ajax/quest/Insert", method: .post, parameters: ["qbMode":ModeIndex[qbMode],], encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                self.alert.showAlert("Done", subTitle: "Your question had updated", style: .success,buttonTitle:"Done"){   Void in
                    self.presentingViewController?.dismiss(animated: true)
                }
                break
                
            case .failure(_):
                self.alert.showAlert("Error", subTitle: "Your question have not updated, because some problem", style: .error)
                break
                
            }
        }
        
    }
}


// APP Button Action

extension CustomAlertViewController  {
    
    @IBAction func doDismiss(_ sender:Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func btHandle(_ sender:Any) {
        let checkQuestionqbID = (sender as AnyObject).tag
        qbMode = checkQuestionqbID!
        createQuestion()
    }
    
}
