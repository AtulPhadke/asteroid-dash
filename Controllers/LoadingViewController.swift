//
//  LoadingViewController.swift
//  scibowl
//
//  Created by Atul Phadke on 10/6/20.
//

import UIKit
import NVActivityIndicatorView

class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light   
        animation()
        // Do any additional setup after loading the view.
    }
    func animation() {
        let frame = CGRect(x: (self.view.center.x - 50), y: (self.view.center.y - 50), width: 100, height: 100)
        
        let loading = NVActivityIndicatorView(frame: frame, type: .ballPulse, color: UIColor(red: 146, green: 255, blue: 186, alpha: 1.0))
        
        view.addSubview(loading)
        
        loading.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5.0) {
            loading.stopAnimating()
            
        }
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .portrait
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
