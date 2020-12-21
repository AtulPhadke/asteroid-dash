//
//  OptionsViewController.swift
//  scibowl
//
//  Created by Atul Phadke on 11/7/20.
//

import UIKit

class OptionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBAction func Exit(_ sender: Any) {
        performSegue(withIdentifier: "optionsChosen", sender: nil)
    }
    var categories = [String]()
    
    var selectedSet: String?
    
    @IBOutlet var chooseCategoriesLabel: UILabel!
    
    var includeExcludeCategories = [String: Bool]()
    
    var players: Array<String>?
    var teamName: String?
    
    var cell_values: Array<Int>?
    
    var myTimer = Timer()
    
    @IBOutlet var optionsTableView: UITableView!
    
    @IBOutlet var showIncorrectQuestions: UISegmentedControl!

    @IBOutlet var showUnseenQuestions: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light   
        chooseCategoriesLabel.text = "Select Categories! Chosen Set: \(selectedSet!)"
        //let value = UIInterfaceOrientation.landscapeLeft.rawValue
        //UIDevice.current.setValue(value, forKey: "orientation")
        setup()
        //self.myTimer = Timer(timeInterval: 0.1, target: self, selector: #selector(refresh(_:)), userInfo: nil, repeats: true)
        //RunLoop.main.add(self.myTimer, forMode: RunLoop.Mode.default)
    }
    
    @objc func refresh(_ timer: Timer) {
        self.optionsTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! CreatePartyViewController
        
        let cells = self.optionsTableView.visibleCells as! Array<OptionsTableViewCell>
        
        for (idx, category) in categories.enumerated() {
            if cell_values![idx] == 1 {
                includeExcludeCategories[category] = true
            } else {
                includeExcludeCategories[category] = false
            }
        }
        if showIncorrectQuestions.selectedSegmentIndex == 1 && showUnseenQuestions.selectedSegmentIndex == 1 {
            let alert = UIAlertController(title: "You have chosen both settings!", message: "Choose between the two!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Show Incorrect Questions!", style: .default, handler: { action in
                destinationVC.unseen = "false"
            }))
            alert.addAction(UIAlertAction(title: "Show Unseen Questions!", style: .default, handler: { action in
                destinationVC.unseen = "true"
            }))
        } else if showIncorrectQuestions.selectedSegmentIndex == 0 && showUnseenQuestions.selectedSegmentIndex == 0 {
            destinationVC.unseen = "nil"
        } else if showIncorrectQuestions.selectedSegmentIndex == 1 && showUnseenQuestions.selectedSegmentIndex == 0 {
            destinationVC.unseen = "false"
        } else if showIncorrectQuestions.selectedSegmentIndex == 0 && showUnseenQuestions.selectedSegmentIndex == 1 {
            destinationVC.unseen = "true"
        }
        print(includeExcludeCategories)
        destinationVC.settingsArray = includeExcludeCategories
        destinationVC.players = players
        destinationVC.teamName = teamName
        destinationVC
        print("HELLO")
        
    }
    
    func setup() {
        
        let imageview = UIImageView(gifImage: try! UIImage(gifName: "background"), loopCount: 1000)
        
        imageview.frame = view.frame
        imageview.contentMode =  UIView.ContentMode.scaleToFill
        self.view.insertSubview(imageview, at: 0)  
        
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        
        //optionsTableView.register(OptionsTableViewCell.self, forCellReuseIdentifier: "setModifier")
        
        cell_values = [0]
        
        for category in categories {
            cell_values!.append(0)
        }
        cell_values?.remove(at: 0)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = optionsTableView.cellForRow(at: indexPath) as! OptionsTableViewCell
        cell.backgroundColor = UIColor.systemGray
        if cell_values![indexPath.row] == 1 {
            cell.backgroundColor = UIColor.clear
            cell_values![indexPath.row] = 0
        } else {
            cell.backgroundColor = UIColor.systemGray
            cell_values![indexPath.row] = 1
        }
        optionsTableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(categories.count)
        //return 1
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        return v
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == optionsTableView {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "setModifier", for: indexPath) as? OptionsTableViewCell {
                print(categories[indexPath.row])
                
                cell.categoryLabel.text = categories[indexPath.row].firstUppercased
                
                cell.layer.borderColor = UIColor.clear.cgColor
                cell.contentView.layer.borderWidth = 4.0
                cell.contentView.layer.borderColor = UIColor.white.cgColor
                //cell.withOrWithoutCategory.tag = indexPath.section
                print(indexPath.row)
                if cell_values![indexPath.row] == 1 {
                    cell.backgroundColor = UIColor.systemGray
                } else {
                    cell.backgroundColor = UIColor.clear
                }
                cell.layer.cornerRadius = 8
                
                return cell
            }
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscape
        } else {
            return .landscape
        }
    }
    override var shouldAutorotate: Bool {
        return true
    }
}
extension StringProtocol {
    var firstUppercased: String { prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { prefix(1).capitalized + dropFirst() }
}
