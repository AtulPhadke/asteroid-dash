//
//  LoginViewController.swift
//  scibowl
//
//  Created by Atul Phadke on 10/7/20.
//

import UIKit
import SwiftyGif

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var usernametextfield: UITextField!
    
    @IBOutlet var partyCodeTextField: UITextField!
    
    @IBOutlet var teamNameTextField: UITextField!
    
    @IBOutlet var desc: UILabel!
    
    var username: String?
    var partyCode: String?
    var teamName: String?
    
    var created_game: Bool?
    var joined_game: Bool?
    
    var backToMain = false
    
    var image = try! UIImage(gifName: "background")
    let imageview = UIImageView(gifImage: try! UIImage(gifName: "background"), loopCount: 20)
    
    var astronaut = try! UIImage(gifName: "astronaut")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light   
        config()
        background()
        astro()
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           // if keyboard size is not available for some reason, dont do anything
           return
        }
      
      // move the root view up by the distance of keyboard height
      self.view.frame.origin.y = 0 - keyboardSize.height
    }
    @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin to zero
      self.view.frame.origin.y = 0
    }
    
    @IBAction func backToMain(_ sender: Any) {
        backToMain = true
        performSegue(withIdentifier: "backToMain", sender: nil)
    }
    
    func background() {
        
        imageview.frame = view.frame
        imageview.contentMode =  UIView.ContentMode.scaleToFill
        self.view.insertSubview(imageview, at: 0)
    }
    
    
    func astro() {
        
        let Omageview = UIImageView(gifImage: astronaut, loopCount: 1000)
        
        Omageview.frame = CGRect(x: 25, y: view.frame.midY*3.7/4, width: 150, height: 150)
        
        self.view.updateConstraintsIfNeeded()
        self.view.layoutIfNeeded()
        //Omageview.translatesAutoresizingMaskIntoConstraints(true)
        
        
        //Omageview.rotateAgain()
        view.addSubview(Omageview)
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue =  Double.pi * 2.0
        animation.duration = 10
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false
        
        let animationX = CABasicAnimation(keyPath: "center.x")

        animationX.duration = 10.0
        
        animationX.toValue = 400
        
        animationX.autoreverses = true
        animationX.repeatCount = .infinity
        
        Omageview.layer.add(animation, forKey: "spin")
        
        
        //UIView.animate(withDuration: 10, delay: 0.3, animations: {
        //Omageview.center.x = 400
        //     }, completion: nil)
        //imageView.layer.add(animation, forKey: "spin")
        //Omageview.layer.add(group, forKey: "move")
    }
    
    func config() {
        
        usernametextfield.delegate = self
        partyCodeTextField.delegate = self
        teamNameTextField.delegate = self
        if created_game == true {
            partyCodeTextField.alpha = 0.0
            desc.text = "Please create a username and a Team Name!"
            //partyCodelabel.text = ""
        } else {
            teamNameTextField.alpha = 0.0
            desc.text = "Please create a username and login with your Party Code!"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if backToMain == false {
            if created_game == true {
                let destinationVC = segue.destination as! CreatePartyViewController
                destinationVC.admin_username = username
                destinationVC.players = [username! as String]
                destinationVC.teamName = teamName
            } else {
                let destinationVC = segue.destination as! JoinPartyViewController
                destinationVC.username = username
                destinationVC.players = [username! as String]
            }
        } else {
            let destinationVC = segue.destination as! ViewController
        }
    }
    
    @IBAction func join_party(_ sender: Any) {
        if created_game == true {
            username = usernametextfield.text
            teamName = teamNameTextField.text
        } else {
            username = usernametextfield.text
            partyCode = partyCodeTextField.text
        }

        if created_game == true && username != "" && teamName != "" {
            print(username, teamName)
            performSegue(withIdentifier: "created_party", sender: "")
        } else if username != "" && partyCode != "" && joined_game == true {
            performSegue(withIdentifier: "joined_party", sender: "")
        }
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscape
        } else {
            return .landscape
        }
    }
}
extension UIView {
    func rotateAgain() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi*4)
        rotation.duration = 20
        rotation.isCumulative = true
        rotation.repeatCount = 2
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}
private var __maxLengths = [UITextField: Int]()
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
               return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        if let t = textField.text {
            textField.text = String(t.prefix(maxLength))
        }
    }
}
