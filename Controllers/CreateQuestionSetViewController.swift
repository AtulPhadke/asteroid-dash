//
//  CreateQuestionSetViewController.swift
//  scibowl
//
//  Created by Atul Phadke on 11/14/20.
//

import UIKit
import SwiftyGif
import UniformTypeIdentifiers
import NVActivityIndicatorView
import CSV
import FirebaseDatabase

class CreateQuestionSetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIDocumentPickerDelegate {
    
    var sets = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        print(files.count)
        if files.count != 1 {
            chooseFileMate = false
            return files.count
        } else {
            chooseFileMate = true
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = filesTableView.dequeueReusableCell(withIdentifier: "files", for: indexPath) as? FilesTableViewCell {
            if chooseFileMate == false {
                //if files[indexPath.section] == "Default" {
                //    cell.filesText.text = "Airdrop a spreadsheet!"
                //}
                if files[indexPath.section] == "Airdrop a spreadsheet!" {
                    cell.iconImg.image = try! UIImage(systemName: "folder.fill.badge.plus")
                } else {
                    cell.iconImg.image = try! UIImage(systemName: "questionmark.folder.fill")
                }
                cell.filesText.text = "\(files[indexPath.section])"
            } else {
                if files[indexPath.section] == "Airdrop a spreadsheet!" {
                    cell.iconImg.image = try! UIImage(systemName: "folder.fill.badge.plus")
                } else {
                    cell.iconImg.image = try! UIImage(systemName: "questionmark.folder.fill")
                }
                cell.filesText.text = "Airdrop a spreadsheet!"
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
        
        if chooseFileMate == true {
            getFiles()
        } else {
            print(indexPath.section)
            if indexPath.section == 0 {
                getFiles()
            } else {
                if setName.text != "" {
                    if sets.contains(setName.text!) {
                        let error = UIAlertController(title: "Your question name has already been taken!", message: "Create a different one!", preferredStyle: .alert)
                        error.addAction(UIAlertAction(title: "Back", style: .default, handler: nil))
                        
                        self.present(error, animated: true)
                    } else {
                        startUPLOAD(path: paths[indexPath.section - 1])
                    }
                } else {
                    let error = UIAlertController(title: "Make a question set name!", message: "Put the name in the text field below.", preferredStyle: .alert)
                    error.addAction(UIAlertAction(title: "Back", style: .default, handler: nil))
                    
                    self.present(error, animated: true)
                }
            }
        }
    }
    
    var files = ["Airdrop a spreadsheet!"]
    var paths = [URL(fileURLWithPath: ".")]
    
    var perms = [String]()
    
    var chosenFile = false
    
    var chooseFileMate = false
    
    let imageview = UIImageView(gifImage: try! UIImage(gifName: "background"), loopCount: 10000000)

    @IBOutlet var setName: UITextField!
    
    @IBAction func backToMain(_ sender: Any) {
        performSegue(withIdentifier: "back", sender: nil)
    }
    
    @IBOutlet var fileFormat: UILabel!
    
    @IBOutlet var filesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        sets = grabSets()
        NotificationCenter.default.addObserver(self, selector: #selector(CreateQuestionSetViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreateQuestionSetViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
        background()
        setup()
        
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
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func background() {
        
        imageview.frame = view.frame
        imageview.tag = 666
        imageview.contentMode =  UIView.ContentMode.scaleToFill
        self.view.insertSubview(imageview, at: 0)
    }
    
    func startUPLOAD(path: URL) {
        for view in view.subviews {
            if view.tag != 666 {
                view.alpha = 0.0
            }
        }
        let loading = NVActivityIndicatorView(frame: .zero, type: .lineScale, color: UIColor.white)
        view.addSubview(loading)
        //view.addSubview(loading)
        
        loading.startAnimating()
        
        DispatchQueue.main.async { [self] in
            let valid = self.compile(path: path)
            if valid == true {
                
                self.chosenFile = true
                loading.stopAnimating()
                
                print(UserDefaults.standard.stringArray(forKey: "perms"))
                
                if UserDefaults.standard.stringArray(forKey: "perms") == nil {
                    perms = [self.setName.text!]
                    UserDefaults.standard.setValue(perms, forKey: "perms")
                    UserDefaults.standard.synchronize()
                } else {
                    perms = UserDefaults.standard.stringArray(forKey: "perms")!
                    perms.append(self.setName.text!)
                    UserDefaults.standard.setValue(perms, forKey: "perms")
                    UserDefaults.standard.synchronize()
                }
                
                var overwrite_bool = false
                
                if perms == self.uniq(source: perms) {
                    overwrite_bool = false
                } else {
                    overwrite_bool = true
                }
                print(overwrite_bool)
                
                if overwrite_bool == true {
                    print("overwrite")
                
                    let overwrite = UIAlertController(title: "You already have a set named '\(self.setName.text!)'!", message: "If you continue your previous set will be overwritten!", preferredStyle: .alert)
                    overwrite.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: { action in
                        self.overwrite(fileURL: path)
                    }))
                    self.present(overwrite, animated: true, completion: nil)
                } else {
                    print("not overwrite")
    
                    self.writeToFirebase(setName: self.setName.text!, fileURL: path)
                    
                    let success = UIAlertController(title: "Success!", message: "You have added '\(self.setName.text!)'", preferredStyle: .alert)
                    success.addAction(UIAlertAction(title: "Continue", style: .default, handler: self.final(_:)))
                    self.present(success, animated: true, completion: nil)
                }
                
            } else {
                self.chosenFile = false
                loading.stopAnimating()
                let success = UIAlertController(title: "Error!", message: "The File that you used is invalid. Make sure you use csv!", preferredStyle: .alert)
                success.addAction(UIAlertAction(title: "Back", style: .default, handler: self.final(_:)))
                self.present(success, animated: true, completion: nil)
            }
        }
    }
    
    func grabSets() -> [String] {
        
        print("Grabbing Sets")
        
        let questionRef = Database.database()
        
        let ref = questionRef.reference(withPath: "Sets/")
        ref.observeSingleEvent(of: .value) { [self] (snapshot) in
            print("BRO")
            
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                //print(rest.key)
                sets.append(rest.key)
            }
        }
        return sets
    }
    
    func overwrite(fileURL: URL) {
        
        writeToFirebase(setName: self.setName.text!, fileURL: fileURL)
        
        let success = UIAlertController(title: "Success!", message: "You have added '\(self.setName.text!)'", preferredStyle: .alert)
        success.addAction(UIAlertAction(title: "Continue", style: .default, handler: self.final(_:)))
        self.present(success, animated: true, completion: nil)
    }
    
    func writeToFirebase(setName: String, fileURL: URL) {
        var ref = Database.database().reference(withPath: "Sets/" + "\(setName)/")
        print("whats poppin")
        print(fileURL.path)
        
        let stream = InputStream(fileAtPath: fileURL.path)!
        
        if let csv = try? CSVReader(stream: stream) {
            print("here")
            while let row = csv.next() {
                if row[1] == "multiple_choices" {
                    print("adding")
                    if row[2] != "" {
                        ref.child(rmchr(string: row[2])).setValue(row[3] + " " + row[4] + " " + row[5] + " " + row[6])
                    }
                    
                } else if row[1] == "short_answer" {
                    print("adding")
                    if row[2] != "" {
                        ref.child(rmchr(string: row[2])).setValue(row[3])
                    }
                }
            }
        }
    }
    
    func rmchr(string: String) -> String {
        return string.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "$", with: "")
    }
    
    func final(_ alert: UIAlertAction) {
        for view in self.view.subviews {
            if view.tag != 666 {
                view.alpha = 1.0
            }
        }
    }
    
    func compile(path: URL) -> Bool {
        print(path, path.pathExtension)
        
        if path.pathExtension == "csv" {
            let stream = InputStream(fileAtPath: path.path)!
            if let csv = try? CSVReader(stream: stream) {
                while let row = csv.next() {
                }
            } else {
                return false
            }
        } else {
            return false
        }
        
        return true
    }
    
    func setup() {
        filesTableView.layer.cornerRadius = 8
        filesTableView.dataSource = self
        filesTableView.delegate = self
    }
    
    func getFiles() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.commaSeparatedText], asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = true
        present(documentPicker, animated: true, completion: nil)
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

    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        for url in urls {
            files.append("\(url.lastPathComponent)")
            paths.append(url)
        }
        print(files)
        print(paths)
        
        files = uniq(source: files)
        paths = uniq(source: urls)
        filesTableView.reloadData()
    }
}

