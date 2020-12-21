//
//  ViewController.swift
//  scibowl
//
//  Created by Atul Phadke on 10/6/20.
//

import UIKit
import NVActivityIndicatorView
import SQLite3
import SpriteKit
import SwiftyGif

class ViewController: UIViewController {
    
    @IBOutlet var join_button: UIButton!
    
    @IBOutlet var create_button: UIButton!
    
    @IBOutlet var add_questions: UIButton!
    
    let emitterNode = SKEmitterNode(fileNamed: "background.sks")!
    
    var joined_game: Bool?
    var created_game: Bool?
    var uiadd_questions: Bool?
    
    var image = try! UIImage(gifName: "space")
    let imageview = UIImageView(gifImage: try! UIImage(gifName: "background"), loopCount: 1000)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        
        background()
        // Do any additional setup after loading the view.
        setupButtons()
        addRain()
        //while true {
        //    if imageview.isAnimatingGif() == false {
        //        background()
        //    }
        //}
    }
    
    func background() {
        
        imageview.frame = view.frame
        imageview.contentMode =  UIView.ContentMode.scaleToFill
        self.view.insertSubview(imageview, at: 0)
    }
    
    func setupButtons() {
        //join_button.isEnabled = false
        join_button.layer.cornerRadius = 7
        create_button.layer.cornerRadius = 7
        add_questions.layer.cornerRadius = 7
        
        create_button.layer.borderWidth = 4
        join_button.layer.borderWidth = 4
        add_questions.layer.borderWidth = 4
        
        create_button.layer.borderColor = UIColor.white.cgColor
        join_button.layer.borderColor = UIColor.white.cgColor
        add_questions.layer.borderColor = UIColor.white.cgColor
        
        self.create_button.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi*0.132))
        
        self.join_button.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi*2.2))
        
        self.add_questions.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 1.8))
        
        //join_button.rotate()
        //create_button.rotate()
        //add_questions.rotate()
    }

    private func addRain() {
        let skView = SKView(frame: view.frame)
        skView.backgroundColor = .clear
        let scene = SKScene(size: view.frame.size)
        scene.backgroundColor = .clear
        skView.presentScene(scene)
        skView.isUserInteractionEnabled = false
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        // scene.addChild(emitterNode)
        emitterNode.position.y = scene.frame.midY
        emitterNode.emissionAngle = .pi
        emitterNode.particlePositionRange.dx = scene.frame.height
        //view.addSubview(skView)
    }
    
    func animation() {
        let frame = CGRect(x: (self.view.center.x - 50), y: (self.view.center.y - 100), width: 100, height: 100)
        let loading = NVActivityIndicatorView(frame: frame, type: .orbit, color: .white, padding: 0)
        view.addSubview(loading)
        
        loading.startAnimating()
        // Trace McSorley is the GOAT
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if uiadd_questions == false {
            let destinationVC = segue.destination as! LoginViewController
            destinationVC.created_game = created_game
            destinationVC.joined_game = joined_game
        } else {
            let destinationVC = segue.destination as! CreateQuestionSetViewController
        }
    }
    @IBAction func join_game(_ sender: Any) {
        self.joined_game = true
        self.created_game = false
        self.uiadd_questions = false
        performSegue(withIdentifier: "login", sender: "")
    }
    @IBAction func create_game(_ sender: Any) {
        self.created_game = true
        self.joined_game = false
        self.uiadd_questions = false
        performSegue(withIdentifier: "login", sender: "")
    }
    
    @IBAction func add_question_set(_ sender: Any) {
        self.uiadd_questions = true
        self.joined_game = false
        self.created_game = false
        performSegue(withIdentifier: "AddQuestion", sender: "")
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscape
        } else {
            return .landscape
        }
    }
    override var shouldAutorotate: Bool {
        return false
    }
}
extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}
extension UIView {
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 1000)
        rotation.duration = Double((12000 ... 18000).randomElement()!)
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}

