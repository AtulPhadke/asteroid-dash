//
//  ImportGoogleSheetsViewController.swift
//  scibowl
//
//  Created by Atul Phadke on 11/21/20.
//

import UIKit
import GoogleSignIn

class ImportGoogleSheetsViewController: UIViewController {
    
    let imageview = UIImageView(gifImage: try! UIImage(gifName: "background"), loopCount: 1000)

    let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    
    @IBAction func back(_ sender: Any) {
        performSegue(withIdentifier: "backToChoose", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        if documents.count == 0 {
            let alert = UIAlertController(title: "You have no files!", message: "Add your csv or xls file to the Files app!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Exit", style: .default, handler: { (alert: UIAlertAction!) in
                self.performSegue(withIdentifier: "backToChoose", sender: nil)
            }))
            
        }
    }
    
    func setup() {
        imageview.frame = view.frame
        imageview.contentMode =  UIView.ContentMode.scaleToFill
        self.view.insertSubview(imageview, at: 0)
    }
}
