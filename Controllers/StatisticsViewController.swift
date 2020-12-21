//
//  StatisticsViewController.swift
//  scibowl
//
//  Created by Atul Phadke on 12/11/20.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    let imageview = UIImageView(gifImage: try! UIImage(gifName: "background"), loopCount: 10000)

    @IBOutlet var incorrectQuestionsLabel: UILabel!
    @IBOutlet var correctQuestionsLabrl: UILabel!
    @IBOutlet var percentageCompletedLabel: UILabel!
    
    var incorrectQuestions: Int?
    var correctQuestions: Int?
    var percentage: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        background()
        setup()

        // Do any additional setup after loading the view.
    }
    
    func setup() {
        incorrectQuestionsLabel.text = "Incorrect Questions: \(incorrectQuestions!)"
        correctQuestionsLabrl.text = "Correct Questions: \(correctQuestions!)"
        if percentage! > 100.0 {
            percentage = 100.0
        }
        percentageCompletedLabel.text = "Percentage completed: %\(percentage!)"
    }
    
    func background() {
        
        imageview.frame = view.frame
        imageview.contentMode =  UIView.ContentMode.scaleToFill
        self.view.insertSubview(imageview, at: 0)
    }
    
    @IBAction func returnToScreen(_ sender: Any) {
        performSegue(withIdentifier: "backToMain", sender: nil)
    }
}
