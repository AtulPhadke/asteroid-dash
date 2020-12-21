//
//  SelectSetViewController.swift
//  scibowl
//
//  Created by Atul Phadke on 11/16/20.
//

import UIKit

class SelectSetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var sets: UITableView!
    
    var sets_list: Array<String>?
    var selected_set: String?
    var teamName: String?
    
    var players: Array<String>?
    
    let imageview = UIImageView(gifImage: try! UIImage(gifName: "background"), loopCount: 1000)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        
        sets.delegate = self
        sets.dataSource = self
        background()
        sets.layer.cornerRadius = 8

    }
    
    func background() {
        
        imageview.frame = view.frame
        imageview.contentMode =  UIView.ContentMode.scaleToFill
        self.view.insertSubview(imageview, at: 0)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sets_list!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        return v
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "sets", for: indexPath) as? SelectSetTableViewCell {
            if sets_list![indexPath.section] == "Default" || sets_list![indexPath.section] == "Level 1" || sets_list![indexPath.section] == "Level 2" || sets_list![indexPath.section] == "Level 3" || sets_list![indexPath.section] == "Level 4" || sets_list![indexPath.section] == "Level 5" {
                
                cell.set_label.text = "HS - " + sets_list![indexPath.section] + " (Science)"
            } else {
                cell.set_label.text = sets_list![indexPath.section]
            }
            if let data = UserDefaults.standard.stringArray(forKey: "incorrectCorrectQuestions-\(sets_list![indexPath.section])") {
                var index = 0
                for dataElement in data {
                    if dataElement == "unseen" {
                        index = index + 1
                    }
                }
                cell.completed_label.text = String(Double(((index/data.count) * 100)).rounded(toPlaces: 2)) + "% " + "Completed"
            } else {
                cell.completed_label.text = "0% " + "Completed"
            }
            
            cell.backgroundColor = UIColor.clear
            cell.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.borderWidth = 4.0
            cell.contentView.layer.borderColor = UIColor.white.cgColor
            
            cell.layer.cornerRadius = 8
            
            cell.clipsToBounds = true
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if sets_list![indexPath.section] == "Default" || sets_list![indexPath.section] == "Level 1" || sets_list![indexPath.section] == "Level 2" || sets_list![indexPath.section] == "Level 3" || sets_list![indexPath.section] == "Level 4" || sets_list![indexPath.section] == "Level 5" {
        
            selected_set = "HS - " + sets_list![indexPath.section] + " (Science)"
            
        } else {
            selected_set = sets_list![indexPath.section]
        }
        
        performSegue(withIdentifier: "set_selected", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CreatePartyViewController
        destinationVC.current_set = selected_set!
        destinationVC.players = players
        destinationVC.teamName = teamName
    }
}
