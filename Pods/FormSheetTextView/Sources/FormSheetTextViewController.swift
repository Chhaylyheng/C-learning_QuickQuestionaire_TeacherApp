//
//  FormSheetTextViewController
//
import UIKit


open class FormSheetTextViewController: UIViewController {
    
    fileprivate var isInitialPositionHead:Bool = false
    
    fileprivate var titleText:String?
    fileprivate var initialText:String?
    fileprivate var cancelButonText:String = "Cancel"
    fileprivate var sendButtonText:String = "Send"
    fileprivate var threadBody: String?
    fileprivate var cc: String?
    fileprivate var ct: String?
    fileprivate var cn: String?

    fileprivate var titleSize:CGFloat?
    fileprivate var buttonSize:CGFloat?

    @IBOutlet weak var composeTextView:UITextView?
    @IBOutlet weak var bodycaption: UITextView!
    
    @IBOutlet weak var editTitle: UITextField!
    @IBOutlet weak var cancelButton:UIBarButtonItem?
    @IBOutlet weak var sendButton:UIBarButtonItem?
    
    @objc open var completionHandler: ((_ sendText: String,_ sendTexts: String) -> Void)?
    
    @objc open static func instantiate() -> FormSheetTextViewController {
        let storyboardsBundle = getStoryboardsBundle()
        let formSheetTextViewController = UIStoryboard(name: "FormSheet", bundle: storyboardsBundle).instantiateInitialViewController() as! FormSheetTextViewController

        return formSheetTextViewController
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCancelButton()
        setUpSendButton()

        self.navigationItem.title = titleText
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = .blue
        
        if (titleSize != nil) {
            self.navigationController?.navigationBar.titleTextAttributes
                = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: titleSize!)]
        }
        
        composeTextView?.text = initialText
        bodycaption?.text = threadBody
        
    }
    
//    override open func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        // Start keyboard display / hidden notification
//        NotificationCenter.default.addObserver(self, selector: #selector(self.UIKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChangeFrame), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//
//        if (isInitialPositionHead) {
//            // Cursor initial position of explanatory area set as head
//            composeTextView?.selectedTextRange = composeTextView?.textRange(from: (composeTextView?.beginningOfDocument)!, to: (composeTextView?.beginningOfDocument)!)
//        }
//
//        composeTextView?.becomeFirstResponder()
//    }
    
    
    // Set Text
    @objc public func allParamater(_ texta:String,_ textb:String,_ textc:String) {
        self.ct = texta
        self.cc = textb
        self.cn = textc
    }
    
    @objc public func setTitleText(_ text:String) {
        self.titleText = text
    }
    
    @objc public func setInitialText(_ text:String) {
        self.initialText = text
    }
    
    @objc public func setBodyText(_ text:String) {
        self.threadBody = text
    }
    
    
    @objc public func setCancelButtonText(_ text:String) {
        self.cancelButonText = text
    }
    
    @objc public func setSendButtonText(_ text:String) {
        self.sendButtonText = text
    }
    
    
    // Size
    @objc public func setTitleSize(_ size:CGFloat) {
        self.titleSize = size
    }
    @objc public func setButtonSize(_ size:CGFloat) {
        self.buttonSize = size
    }
    
    
    // Mark: Bar Item action
    @objc private func cancel(sender:UIBarButtonItem) {
        self.dismiss(animated: true, completion:nil)
    }
    @objc private func send(sender:UIBarButtonItem) {

//        if (composeTextView?.text?.isEmpty)! {
//            //print("title empty","#")
//            let alertController:UIAlertController = UIAlertController(title:nil, message: "There is no thread title. Please enter.", preferredStyle: UIAlertControllerStyle.alert)
//            let cancelAction:UIAlertAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel, handler:{ (action:UIAlertAction!) -> Void in
//            })
//            alertController.addAction(cancelAction)
//            self.present(alertController, animated: true, completion: nil)
//        }
//        if (bodycaption?.text?.isEmpty)! {
//            //print("body empty","#")
//            let alertController:UIAlertController = UIAlertController(title:nil, message: "There is no thread body. Please enter.", preferredStyle: UIAlertControllerStyle.alert)
//            let cancelAction:UIAlertAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel, handler:{ (action:UIAlertAction!) -> Void in
//            })
//            alertController.addAction(cancelAction)
//            self.present(alertController, animated: true, completion: nil)
//        }
        
//        print(composeTextView?.text,"#")
//        print(bodycaption?.text,"#")
//        print(cc!,"cc #")
//        print(ct!,"ct #")
//        print(cn!,"cn #")
        
        if completionHandler != nil {
            completionHandler!((composeTextView?.text)!,(bodycaption?.text)!)
        }
        
    }
    
    static func getStoryboardsBundle() -> Bundle {
        let podBundle = Bundle(for: FormSheetTextViewController.self)
        let bundleURL = podBundle.url(forResource: "Storyboards", withExtension: "bundle")
        let bundle = Bundle(url: bundleURL!)!
        
        return bundle
    }
    
//    @objc func UIKeyboardWillShow(notification: NSNotification) {
//        keyboardWillChangeFrame(notification: notification)
//    }
    
//    @objc func keyboardWillChangeFrame(notification: NSNotification) {
//        let info: [AnyHashable: Any]? = notification.userInfo
//
//        let windowHeight = UIScreen.main.bounds.size.height
//
//        // キーボードの大きさを取得
//        let keyboardRect = (info?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//        let keyboardHeight = keyboardRect.size.height
//
//        // Form Sheet(UIModalPresentationFormSheet) 高さ
//        let formSheetHeight:CGFloat! = self.view.superview?.frame.size.height
//
//        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad) {
//            // iPadの場合
//            if UIDevice.current.orientation.isLandscape {
//                let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
//
//                // キーボードの高さ - form sheetの下の余白の高さ
//                bottomConstraint.constant = keyboardHeight - ((windowHeight - formSheetHeight - statusBarHeight)) + 10
//            } else {
//                bottomConstraint.constant = keyboardHeight - ((windowHeight - formSheetHeight) / 2) + 10
//            }
//        } else {
//            bottomConstraint.constant = keyboardHeight + 10
//        }
//
//
//        let duration = CDouble(info?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval ?? TimeInterval())
//        UIView.animate(withDuration: duration, animations: {() -> Void in
//            self.view.layoutIfNeeded()
//        })
//    }
    
//    @objc func keyboardWillHide(_ notification: Notification) {
//        let info: [AnyHashable: Any]? = notification.userInfo
//        bottomConstraint.constant = 10
//
//        let duration = CDouble(info?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval ?? TimeInterval())
//        UIView.animate(withDuration: duration, animations: {() -> Void in
//            self.view.layoutIfNeeded()
//        })
//    }
//
    func setUpCancelButton() {
        
        let leftButton = UIBarButtonItem(title: cancelButonText, style: UIBarButtonItemStyle.plain, target: self, action:#selector(FormSheetTextViewController.cancel(sender:)))
        
        if (buttonSize != nil) {
            leftButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: buttonSize!)], for: UIControlState.normal)
        }
        
        self.navigationItem.leftBarButtonItem = leftButton
    }

    
    func setUpSendButton() {
        let rightButton = UIBarButtonItem(title: sendButtonText, style: UIBarButtonItemStyle.plain, target: self, action: #selector(FormSheetTextViewController.send(sender:)))
        
        if (buttonSize != nil) {
            rightButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: buttonSize!)], for: UIControlState.normal)
        }
        
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    
    @objc public func setIsInitialPositionHead(_ isInitialPositionHead:Bool) {
        self.isInitialPositionHead = isInitialPositionHead
    }
    
    
//    func updateThread() {
//        let titleText = composeTextView?.text
//        let bodytext = bodycaption?.text
//
//        var request = URLRequest(url: URL(string: "https://kit.c-learning.jp/t/ajax/coop/CoopReply")!)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let parameters = ["m":"edit","ct":"c398223976","cc":"m733190178","cn":"315","c_title":"helloword","c_text":"why"]
//        do {
//            if #available(iOS 11.0, *) {
//                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
//            } else {
//                // Fallback on earlier versions
//            } // pass dictionary to nsdata object and set it as request body
//        } catch let error {
//            print(error.localizedDescription)
//        }
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if error != nil {
//                //
//            } else {
//                if let data = data {
//                    do {
//                        let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any]
//                        print(json!, "*")
//
//                        let alertController:UIAlertController = UIAlertController(title:nil, message: "Thread Updated", preferredStyle: UIAlertControllerStyle.alert)
//                        let cancelAction:UIAlertAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.cancel, handler:{ (action:UIAlertAction!) -> Void in
//                        })
//                        alertController.addAction(cancelAction)
//
//                    } catch {
//                        print("error")
//                    }
//                }
//            }
//
//        }
//        task.resume()
//
//    }
    
}
