//
//  GameViewController.swift
//  scibowl
//
//  Created by Atul Phadke on 11/1/20.
//

import UIKit
import SpriteKit
import GameplayKit
import GameKit


class GameViewController: UIViewController {
    
    var settingsArray: [String: Bool]?
    var questionTime: Double?
    var teams: [String]?
    var currentSet: String?
    var unseen: String?
    
    let scene = GameScene(size: CGSize(width: 667, height: 375))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light   
        guard let skView = self.view as? SKView else { return }
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
         
        scene.settingsArray = settingsArray
        scene.teams = teams
        scene.questionTime = questionTime!
        scene.nilChangeQuestionTime = questionTime!
        scene.currentSet = currentSet
        scene.unseen = unseen
        
        //skView.showsFPS = true
        //skView.showsNodeCount = true

        skView.ignoresSiblingOrder = true
        
        scene.scaleMode = .aspectFit

        skView.presentScene(scene)
        let queue = DispatchQueue(label: "Game")
        
        queue.async { [self] in
            while true {
                if scene.EXITGAME == true {
                    DispatchQueue.main.sync {
                        self.performSegue(withIdentifier: "backToGameScreen", sender: self)
                        
                    }
                    break
                }
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! StatisticsViewController
        
        destinationVC.correctQuestions = scene.correctQuestions
        destinationVC.incorrectQuestions = scene.incorrectQuestions
        destinationVC.percentage = scene.percentage
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscape
        } else {
            return .landscape
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
