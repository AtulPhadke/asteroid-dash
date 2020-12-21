//
//  JoinPartyViewController.swift
//  scibowl
//
//  Created by Atul Phadke on 11/14/20.
//

import UIKit

class JoinPartyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var username: String?
    var players = [String]()
    
    @IBOutlet var playerTableView: UITableView!
    
    let imageview = UIImageView(gifImage: try! UIImage(gifName: "background"), loopCount: 1000)

    @IBOutlet var countdown: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light   
        playerTableView.dataSource = self
        playerTableView.delegate = self
        playerTableView.layer.cornerRadius = 8
        background()
        countdown.alpha = 0.0

        // Do any additional setup after loading the view.
    }
    
    func background() {
        
        imageview.frame = view.frame
        imageview.contentMode =  UIView.ContentMode.scaleToFill
        self.view.insertSubview(imageview, at: 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "playersReuse", for: indexPath) as? JoinPartyTableViewCell {
            
            //cell.backgroundColor = UIColor.clear
            cell.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.borderWidth = 4.0
            cell.contentView.layer.borderColor = UIColor.white.cgColor
            
            cell.layer.cornerRadius = 8
            
            cell.playerText.text = players[indexPath.section] as! String
            cell.teamNumber.text = "Team Number 1"
            
            cell.astronaut.gifImage = try! UIImage(gifName: "astronaut")
            cell.astronaut.loopCount = 1000
            
            cell.clipsToBounds = true
            
            return cell
        }
        return UITableViewCell()
    }
    
    @IBAction func back(_ sender: Any) {
        performSegue(withIdentifier: "backTohomescreen", sender: nil)
    }
}
