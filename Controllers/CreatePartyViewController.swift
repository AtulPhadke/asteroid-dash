//
//  CreatePartyViewController.swift
//  scibowl
//
//  Created by Atul Phadke on 10/10/20.
//

import UIKit
import FirebaseDatabase
//import GameKit
import SwiftyGif
import NVActivityIndicatorView
import GameKit

class CreatePartyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,  UIPickerViewDataSource, UIPickerViewDelegate {

    let emitterNode = SKEmitterNode(fileNamed: "background.sks")!
    
    @IBOutlet var partyCode: UILabel!
    @IBOutlet var selected_set_label: UILabel!
    
    var teamName: String?
    
    var grabbedCategories:Bool = false
    
    var current_set = "HS - Default (Science)"
    
    @IBOutlet var tableView: UITableView!

    @IBOutlet var setTableView: UITableView!
    
    var admin_username: String?
    
    var players: Array<String>?
    let questionRef = Database.database()
    
    let imageview = UIImageView(gifImage: try! UIImage(gifName: "background"), loopCount: 1000)
    
    var sets = [String]()
    var categories = [String:[String]]()
    
    var optionsAlreadySetup: Bool?

    @IBOutlet var numberTeams: UIStepper!
    
    @IBOutlet var numberTeamsLabel: UILabel!
    
    @IBOutlet var segmentedMultiplayer: UISegmentedControl!
    
    var pickerView: UIPickerView!
    var pickerData: [String]!
    
    var settingsArray: [String: Bool]?
    
    @IBOutlet var multiTitle: UILabel!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var selectSetButton: UIButton!
    @IBOutlet var optionsBUtton: UIButton!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var adjustTeams: UILabel!
    
    @IBOutlet var backButton: UIButton!
    
    var unseen: String?
    
    var teams: [String]!
    var code = ""
    
    var nil_options = false
    
    var set_options = false
    
    var set_picker = false
    
    var start = false
    
    @IBAction func options(_ sender: Any) {
        
        start = false
        nil_options = false
        set_picker = false
        set_options = true
        
        let animator = NVActivityIndicatorView(frame: .zero, type: .ballScaleMultiple, color: UIColor.white)
        
        animator.startAnimating()
        
        DispatchQueue.main.async { [self] in
            while true {
                if categories.count != 0 {
                    print(categories.count)
                    print(current_set)
                    animator.stopAnimating()
                    performSegue(withIdentifier: "options", sender: nil)
                    break
                }
            }
        }
    }
    
    @IBAction func selectanotherset(_ sender: Any) {
        
        start = false
        nil_options = false
        set_options = false
        set_picker = true
        performSegue(withIdentifier: "select_set", sender: nil)
    }
    @IBAction func numberOfTeams(_ sender: UIStepper) {
        
        numberTeamsLabel.text = "\(sender.value) seconds"
        self.pickerData = [teamName!]
        print(self.pickerData)
    }
    @IBAction func backToTitleScreen(_ sender: Any) {
        
        start = false
        set_options = false
        nil_options = true
        set_picker = false
        
        performSegue(withIdentifier: "backToTitleScreen", sender: "")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(set_options)
        print(nil_options)
        print(set_picker)
        print(start)
        if set_options == true {
            
            let destinationVC = segue.destination as! OptionsViewController
            //let myGroup = DispatchGroup()
            print(current_set)
            if current_set == "HS - Default (Science)" || current_set == "HS - Level 1 (Science)" || current_set == "HS - Level 2 (Science)" || current_set == "HS - Level 3 (Science)" || current_set == "HS - Level 4 (Science)" || current_set == "HS - Level 5 (Science)" {
                current_set = current_set.replacingOccurrences(of: " (Science)", with: "")
                current_set = current_set.replacingOccurrences(of: "HS - ", with: "")
            }
            destinationVC.categories = categories[current_set]!
            destinationVC.selectedSet = current_set
            destinationVC.players = players
            destinationVC.teamName = teamName
        }
            
        if nil_options == true {
            
            let destinationVC = segue.destination as! ViewController
        }
        
        if set_picker == true {
            
            let destinationVC = segue.destination as! SelectSetViewController
            destinationVC.sets_list = sets
            destinationVC.players = players
            destinationVC.teamName = teamName
        }
        if start == true {
            
            let destinationVC = segue.destination as! GameViewController
            if settingsArray == nil {
                //print(settingsArray)
                destinationVC.settingsArray = nil
            } else {
                print(settingsArray)
                destinationVC.settingsArray = settingsArray
            }
            destinationVC.questionTime = numberTeams.value
            destinationVC.teams = teams
            destinationVC.currentSet = current_set
            destinationVC.unseen = unseen
        }
    }
    
    func background() {
        
        imageview.frame = view.frame
        imageview.contentMode =  UIView.ContentMode.scaleToFill
        self.view.insertSubview(imageview, at: 0)
    }
    
    private func addRain() {
        let skView = SKView(frame: view.frame)
        skView.backgroundColor = .clear
        
        let scene = SKScene(size: view.frame.size)
        scene.backgroundColor = .clear
        skView.presentScene(scene)
        skView.isUserInteractionEnabled = false
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.addChild(emitterNode)
        emitterNode.position.y = scene.frame.maxY
        emitterNode.particlePositionRange.dx = scene.frame.width
        view.addSubview(skView)
    }
    
    @IBAction func startNL(_ sender: Any) {
        
        start = true
        set_options = false
        nil_options = false
        set_picker = false
        performSegue(withIdentifier: "started", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light   
        //let value = UIInterfaceOrientation.landscapeLeft.rawValue
        //UIDevice.current.setValue(value, forKey: "orientation")
        //print(getIP())
        //let queue = DispatchQueue(label: "gettingSet")
        //queue.async { [self] in
        //   while true {
        //        if grabbedCategories == true {
        //            DispatchQueue.main.async {
        beforeSetup()
        generateCode()
        background()
        numberTeams.layer.cornerRadius = 8
        //tableView.register(CreatePartyTableViewCell.self, forCellReuseIdentifier: "playerCell")
        tableView.delegate = self
        tableView.dataSource = self
        setTableView.delegate = self
        setTableView.dataSource = self
        pickerView = UIPickerView(frame: CGRect(x: 10, y: 50, width: 250, height: 150))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerData = [teamName!]
        self.teams = [teamName!]
        self.tableView.reloadData()
        self.setTableView.reloadData()
        let thread = DispatchQueue(label: "LOADING")
        
        let loading = NVActivityIndicatorView(frame: .zero, type: .circleStrokeSpin, color: .white, padding: 0.0)
        loading.startAnimating()
        
        thread.async { [self] in
            self.grabSets()
            while true {
                if grabbedCategories == true {
                    DispatchQueue.main.async {
                        loading.stopAnimating()
                        setup()
                        render()                        //addRain()
                        createParty()
                    }
                    break
                }
            }
        }
        //            }
        //break
        // Do any additional setup after loading the view.
    }
    
    func beforeSetup() {
        tableView.alpha = 0.0
        partyCode.alpha = 0.0
        selected_set_label.alpha = 0.0
        numberTeamsLabel.alpha = 0.0
        numberTeams.alpha = 0.0
        titleLabel.alpha = 0.0
        optionsBUtton.alpha = 0.0
        selectSetButton.alpha = 0.0
        adjustTeams.alpha = 0.0
        startButton.alpha = 0.0
        backButton.alpha = 0.0
        multiTitle.alpha = 0.0
        segmentedMultiplayer.alpha = 0.0
    }
    
    
    func setup() {
        segmentedMultiplayer.setEnabled(false, forSegmentAt: 1)
        tableView.alpha = 1.0
        partyCode.alpha = 1.0
        selected_set_label.alpha = 1.0
        numberTeamsLabel.alpha = 1.0
        numberTeams.alpha = 1.0
        titleLabel.alpha = 1.0
        optionsBUtton.alpha = 1.0
        selectSetButton.alpha = 1.0
        adjustTeams.alpha = 1.0
        startButton.alpha = 1.0
        backButton.alpha = 1.0
        multiTitle.alpha = 1.0
        segmentedMultiplayer.alpha = 1.0
        
    }
    func grabSets() {
        
        print("Grabbing Sets")
        let ref = questionRef.reference(withPath: "Sets/")
        ref.observeSingleEvent(of: .value) { [self] (snapshot) in
            print("BRO")
            var perms = [""]
            
            if UserDefaults.standard.stringArray(forKey: "perms") == nil {
                perms = [""]
            } else {
                perms = UserDefaults.standard.stringArray(forKey: "perms")!
            }
            
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                print(rest.key)
                if rest.key == "Default" || rest.key == "Level 1" || rest.key == "Level 2" || rest.key == "Level 3" || rest.key == "Level 4" || rest.key == "Level 5" {
                    sets.append(rest.key)
                } else if rest.key == "MS - Level 1 (Science)" || rest.key == "MS - Level 2 (Science)" || rest.key == "MS - Level 3 (Science)" || rest.key == "MS - Level 4 (Science)" || rest.key == "MS - Level 5 (Science)" {
                    sets.append(rest.key)
                } else {
                    if perms.contains(rest.key) {
                        sets.append(rest.key)
                    }
                }
            }
            grabCategories()
        }
    }
    
    func grabCategories() {
        
        for set in sets {
            
            print("hello: " +  set)
            
            let ref = questionRef.reference(withPath: "Sets/" + set + "/")
            ref.observeSingleEvent(of: .value) { [self] snapshot in
                var current_set_categories = [String]()
                for rest in snapshot.children.allObjects as! [DataSnapshot] {
                    let category = rest.key.lowercased().split(separator: " ")
                    
                    current_set_categories.append(String(category[0]))
                }
                current_set_categories = uniq(source: current_set_categories)
                print(current_set_categories)
                self.categories[set] = current_set_categories
            }
        }
        grabbedCategories = true
    }
    
    func uniq<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }

    
    func createParty() {

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == setTableView {
            return sets.count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableView {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as? CreatePartyTableViewCell {
                if indexPath.row > players!.count - 1 {
                    
                } else {
                    print(players)
                    
                    cell.playerUsername.text = players![indexPath.row] as! String
                    cell.teamNumberLabel.text = "Team \(teams[indexPath.row])"
                    
                    cell.astronaut.gifImage = try! UIImage(gifName: "astronaut")
                    cell.astronaut.loopCount = 1000
                    
                    //cell.backgroundColor = UIColor.clear
                    
                    cell.backgroundColor = UIColor.clear
                    cell.layer.borderColor = UIColor.clear.cgColor
                    cell.contentView.layer.borderWidth = 4.0
                    cell.contentView.layer.borderColor = UIColor.white.cgColor
                    
                    cell.layer.cornerRadius = 8
                    
                    cell.clipsToBounds = true
                    
                    return cell
                }
            }
        }
        return UITableViewCell()
        
    }    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == setTableView {
            current_set = sets[indexPath.row] as! String
            selected_set_label.text = "Selected Set: " + current_set
            
        } else {
            showAlert(indexPath: indexPath)

        }
    }
    
    func render() {
        renderCode()
        renderSet()
    }
    
    func renderSet() {
        selected_set_label.text = "Selected Set: " + current_set
    }
    
    func renderCode() {
        partyCode.text = "Party Code: " + "XXXXXX"
        view.addSubview(partyCode)
    }
    
    
    func generateCode() {
        
        self.code = randomAlphaNumericString(length: 5)
        
    }
    
    func randomAlphaNumericString(length: Int) -> String {
        let allowedChars = "0123456789ABCDEF"
        
        let allowedCharsCount =
            UInt32(allowedChars.count)
        
        var randomString = ""

        for _ in 0 ..< length {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
            let newCharacter = allowedChars[randomIndex]
            randomString += String(newCharacter)
        }

        return randomString
    }
    
    func showAlert(indexPath:  IndexPath) {
        let ac = UIAlertController(title: "Team Picker", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        pickerView.reloadAllComponents()
        ac.view.addSubview(pickerView)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [self] _ in
            let pickerValue = self.pickerData[self.pickerView.selectedRow(inComponent: 0)]
            print("Picker value: \(pickerValue) was selected")
            self.teams[indexPath.row] = pickerValue
            tableView.reloadData()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(self.pickerData[row])"
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

