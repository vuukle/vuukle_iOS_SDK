import UIKit

protocol AddCommentCellDelegate {
    
    func postButtonPressed(tableCell : AddCommentCell ,pressed postButton : AnyObject )
    func logOutButtonPressed(tableCell : AddCommentCell ,pressed logOutButton : AnyObject )
}


class AddCommentCell: UITableViewCell , UITextViewDelegate , UITextFieldDelegate {
    var delegate : AddCommentCellDelegate?
    let defaults : UserDefaults = UserDefaults.standard
    
    var indexRow = 1
    
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var commentTextView: UITextView!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var background: UIView!
    
    @IBOutlet weak var postButtonOutlet: UIButton!
    
    @IBOutlet weak var leftConstrainSize: NSLayoutConstraint!
    
    @IBOutlet weak var totalCount: UILabel!
    
    @IBOutlet weak var greetingLabel: UILabel!
    
    @IBOutlet weak var totalCountHeight: NSLayoutConstraint!
    
    @IBOutlet weak var logOutButtonHeight: NSLayoutConstraint!
    
    @IBOutlet weak var backgroundHeight: NSLayoutConstraint!
    
    @IBOutlet weak var logOut: UIButton!
    
    @IBAction func postButton(sender: AnyObject) {
        
        postButtonOutlet.isEnabled = false
        self.delegate?.postButtonPressed(tableCell: self ,pressed: sender)
    }
    
    @IBAction func logOutButton(sender: AnyObject) {
        
        logOut.isEnabled = false
        self.delegate?.logOutButtonPressed(tableCell: self, pressed: sender)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [unowned self] in
            self.logOut.isEnabled = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        background.layer.cornerRadius = 5
        postButtonOutlet.layer.cornerRadius = 5
        commentTextView.layer.cornerRadius = 5
        nameTextField.layer.cornerRadius = 5
        emailTextField.layer.cornerRadius = 5
        
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.borderColor = UIColor.lightGray.cgColor
        
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.lightGray.cgColor
        
        background.layer.borderWidth = 1
        background.layer.borderColor = UIColor.lightGray.cgColor
        
        commentTextView.text = "Please write a comment..."
        commentTextView.textColor = UIColor.lightGray
        commentTextView.delegate = self
        
        let viewForDoneButtonOnKeyboard = UIToolbar()
        viewForDoneButtonOnKeyboard.sizeToFit()
        let btnDoneOnKeyboard = UIBarButtonItem(title: "Done",
                                                style: .plain,
                                                target: self,
                                                action: #selector(doneBtnFromKeyboardClicked(sender:)))
        viewForDoneButtonOnKeyboard.setItems([btnDoneOnKeyboard], animated: false)
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        
        nameTextField.inputAccessoryView = viewForDoneButtonOnKeyboard
        emailTextField.inputAccessoryView = viewForDoneButtonOnKeyboard
        commentTextView.inputAccessoryView = viewForDoneButtonOnKeyboard
        
        commentTextView.returnKeyType = UIReturnKeyType.default
        nameTextField.returnKeyType = UIReturnKeyType.done
        emailTextField.returnKeyType = UIReturnKeyType.done
        
        //emailTextField.enablesReturnKeyAutomatically = true
        //nameTextField.enablesReturnKeyAutomatically = true
        
        logOut.layer.cornerRadius = 5
        logOut.layer.masksToBounds = true
    }
    
    
    //MARK: - Handling of keyboard for UITextField
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        var superView = textField.superview?.superview?.superview?.superview?.superview
        var isСontinueSearch = true
        
        while isСontinueSearch {
            
            if !(superView is UIWindow) {
                
                if superView?.superview is UIScrollView {
                    
                    isСontinueSearch = false
                    superView = superView?.superview
                    
                    var scrollView = superView as! UIScrollView
                    print("\n \(scrollView)")
                    
                    var pointInScroll: CGPoint = textField.superview!.convert(textField.frame.origin, to: scrollView)
                    
                    var contentOffset: CGPoint = scrollView.contentOffset
                    contentOffset.y  = pointInScroll.y
                    
                    if let accessoryView = textField.inputAccessoryView {
                        
                        if (UIDevice.current.orientation.isLandscape) {
                            switch UIScreen.main.bounds.height {
                            case 375:
                                contentOffset.y -= accessoryView.frame.size.height
                            case 414:
                                contentOffset.y -= accessoryView.frame.size.height + 20
                            default:
                                contentOffset.y -= accessoryView.frame.size.height
                            }
                        } else {
                            switch UIScreen.main.bounds.width {
                            case 320:
                                switch UIScreen.main.bounds.height {
                                case 480:
                                    contentOffset.y -= accessoryView.frame.size.height + 30
                                default:
                                    contentOffset.y -= accessoryView.frame.size.height + 120
                                }
                            case 375:
                                contentOffset.y -= accessoryView.frame.size.height + 190
                            case 414:
                                contentOffset.y -= accessoryView.frame.size.height + 230
                            default:
                                contentOffset.y -= accessoryView.frame.size.height + 100
                            }
                        }
                    }
                    scrollView.setContentOffset(contentOffset, animated: true)
                    
                } else {
                    superView = superView?.superview
                }
            } else {
                print("\n-- Stop...")
                isСontinueSearch = false
            }
        }
        return true
        
    }
    
    //MARK: - Handling of keyboard for UITextView
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        var superView = textView.superview?.superview?.superview?.superview?.superview
        var isСontinueSearch = true
        
        while isСontinueSearch {
            
            if !(superView is UIWindow) {
                
                if superView?.superview is UIScrollView {
                    
                    isСontinueSearch = false
                    
                    superView = superView?.superview
                    
                    var scrollView = superView as! UIScrollView
                    print("\n \(scrollView)")
                    
                    var pointInScroll: CGPoint = textView.superview!.convert(textView.frame.origin, to: scrollView)
                    
                    var contentOffset: CGPoint = scrollView.contentOffset
                    contentOffset.y  = pointInScroll.y
                    
                    if let accessoryView = textView.inputAccessoryView {
                        
                        if (UIDevice.current.orientation.isLandscape) {
                            contentOffset.y -= accessoryView.frame.size.height
                        } else {
                            switch UIScreen.main.bounds.width {
                            case 320:
                                switch UIScreen.main.bounds.height {
                                case 480:
                                    contentOffset.y -= accessoryView.frame.size.height
                                default:
                                    contentOffset.y -= accessoryView.frame.size.height + 30
                                }
                            case 375:
                                contentOffset.y -= accessoryView.frame.size.height + 50
                            case 414:
                                contentOffset.y -= accessoryView.frame.size.height + 80
                            default:
                                contentOffset.y -= accessoryView.frame.size.height
                            }
                        }
                    }
                    scrollView.setContentOffset(contentOffset, animated: true)
                    
                } else {
                    superView = superView?.superview
                }
            } else {
                print("\n-- Stop...")
                isСontinueSearch = false
            }
        }
        return true
    }
    
    //MARK: -
    func doneBtnFromKeyboardClicked(sender : UIBarButtonItem) {
        
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        commentTextView.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if commentTextView.textColor == UIColor.lightGray {
            commentTextView.text = ""
            commentTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if commentTextView.text.isEmpty {
            commentTextView.text = "Please write a comment..."
            commentTextView.textColor = UIColor.lightGray
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        commentTextView.text = ""
    }
    
    
    func showProgress() {
        self.alpha = 0.4
        progressIndicator.startAnimating()
        progressIndicator.isHidden = false
        //commentTextView.a
    }
    
    func hideProgress() {
        
        progressIndicator.isHidden = true
        progressIndicator.stopAnimating()
        self.alpha = 1
    }
    
}
