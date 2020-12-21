//
//  GameScene.swift
//  scibowl-game
//
//  Created by Atul Phadke on 10/7/20.
//

import SpriteKit
import FirebaseDatabase
import AVFoundation
import SwiftyGif
import GameKit

class GameScene: SKScene, UITableViewDelegate, UITableViewDataSource {
    
    /// Exit Button
    /// Failed Question Help
    
    var correctQuestions = 0
    var incorrectQuestions = 0
    var percentage = 0.00
    var stoppedThread = false
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return teams!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == teamPoints {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "teams", for: indexPath) as? GameSceneTeamsTableViewCell {
                
                cell.backgroundColor = UIColor.clear
                cell.layer.borderColor = UIColor.clear.cgColor
                cell.contentView.layer.borderWidth = 4.0
                cell.contentView.layer.borderColor = UIColor.white.cgColor
                cell.contentView.layer.cornerRadius = 8
                
                cell.layer.cornerRadius = 8
                
                cell.teamName.textAlignment = .left
                cell.teamPoints.textAlignment = .right
                
                return cell
            }
            
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "players", for: indexPath) as? GameScenePlayersTableViewCell {
                
                cell.backgroundColor = UIColor.clear
                cell.layer.borderColor = UIColor.clear.cgColor
                cell.contentView.layer.borderWidth = 4.0
                cell.contentView.layer.borderColor = UIColor.white.cgColor
                cell.contentView.layer.cornerRadius = 8
                
                cell.layer.cornerRadius = 8
                
                cell.playerPoints.textAlignment = .right
                cell.playerName.textAlignment = .left
                
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var unseen: String?
    var background = SKSpriteNode(imageNamed: "landscape")
    var asteroidNext = SKSpriteNode()
    var asteroidExit = SKSpriteNode()
    var player = SKSpriteNode()
    var icon = SKSpriteNode()
    var currentSet: String?
    var asteroidA = SKSpriteNode()
    var asteroidB = SKSpriteNode()
    var asteroidC = SKSpriteNode()
    var asteroidD = SKSpriteNode()
    var explanation = SKLabelNode(fontNamed: "DIN Condensed")
    var playersPoints = UITableView()
    var teamPoints = UITableView()
    var asteroidScore = SKSpriteNode()
    var settingsArray: [String: Bool]!
    var validQuestions: [Int]!
    var asteroidBuzzer = SKSpriteNode()
    var questionLabel = SKLabelNode(fontNamed: "DIN Condensed")
    var width: CGFloat?
    var height: CGFloat?
    var multipleChoice = true
    var receiveAnswers = false
    let questionRef = Database.database()
    var questions: [String] = []
    var answers: [String] = []
    var combined: [Any] = []
    var firstQuestion = true
    var first_question_render = true
    var first_asteroid_render = true
    var first_asteroid_buzzer_render = true
    var timeLeftShapeLayer = CAShapeLayer()
    var bgShapeLayer = CAShapeLayer()
    var timeLeft: TimeInterval = 60.0
    var endTime: Date?
    let strokeIt = CABasicAnimation(keyPath: "strokeEnd")
    var image = SKSpriteNode(imageNamed: "thought.png")
    var textBubble = UIImageView(image: try! UIImage(imageName: "thought.png"))
    let timer = SKLabelNode(fontNamed: "Peepo")
    var alertController: UIAlertController!
    var questionTime: Double?
    var nilChangeQuestionTime: Double?
    var levelTimer = Timer()
    var waiting_for_answer = true
    var question_running = true
    var got_correct_answer = false
    var got_incorrect_answer = false
    var got_no_answer = false
    let enterShortAnswer = UITextField()
    var mask: UIView!
    var personal_score = 0
    var answered = ""
    var team_scores = [Int]()
    var teams: [String]?
    var waitingForAsteroidNextToBePressed = false
    var assignNextQuestion = false
    var incorrectCorrectQuestionsDictionary = [String: String]()
    
    var exitButton = UIImageView(image: try! UIImage(imageName: "asteroid_scoreExit"))
    
    var scores: [Int]?
    
    var scoresShown = false
    
    var EXITGAME = false

    // init - start
    override func didMove(to view: SKView) {
        
        for _ in teams! {
            team_scores.append(0)
        }
        
        asteroidNext.texture = SKTexture(imageNamed: "asteroid_next")
        asteroidNext.name = "asteroidNext"
        
        asteroidExit.texture = SKTexture(imageNamed: "asteroid_Exit")
        asteroidExit.name = "asteroidExitScreen"
        
        exitButton.frame = CGRect(x: frame.midX - 137*0.35, y: frame.midY - 114*0.35, width: 137*0.7, height: 114*0.7)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        exitButton.isUserInteractionEnabled = true
        exitButton.addGestureRecognizer(tapGestureRecognizer)
        
        //barChartView.noDataText = "You need to provide data for the chart.
        self.width = frame.size.width
        self.height = frame.size.height
        
        mask = UIView(frame: view.frame)
        
        playersPoints.frame = CGRect(x: frame.midX/2 - 100, y: frame.midY - 50, width: 200, height: 100)
        playersPoints.register(GameScenePlayersTableViewCell.self, forCellReuseIdentifier: "players")
        playersPoints.delegate = self
        playersPoints.dataSource = self
        playersPoints.backgroundColor = UIColor.clear
        
        teamPoints.frame = CGRect(x: 3*frame.width/4 - 100, y: frame.midY - 50, width: 200, height: 100)
        teamPoints.register(GameSceneTeamsTableViewCell.self, forCellReuseIdentifier: "teams")
        teamPoints.delegate = self
        teamPoints.dataSource = self
        teamPoints.backgroundColor = UIColor.clear
        
        enterShortAnswer.frame = CGRect(x: frame.size.width/4, y: frame.size.height/4, width: frame.size.width/2, height: frame.size.height/1.5)
    
        mask.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        
        getQuestions()
        
        asteroidA.isPaused = false
        asteroidB.isPaused = false
        asteroidC.isPaused = false
        asteroidD.isPaused = false
        
        questionLabel.isPaused = false
        
        asteroidBuzzer.isPaused = false
        
        renderBackground()
        
        player = SKSpriteNode()
        player.texture = SKTexture(imageNamed: "astronaut_pic")
        player.size = CGSize(width: 50, height: 50)
        
        player.position = CGPoint(x: frame.midX, y: frame.midY + self.height!/2)
        player.zPosition = 1.0
        
        self.addChild(player)
        
        let point = CGPoint(x: self.frame.midX, y: self.frame.midY - self.height!/4)
        
        let action = SKAction.move(to: point, duration: 5)
        let changeSize = SKAction.scale(to: 2.0, duration: 5)
        let rotation = SKAction.rotate(byAngle: .pi * 6, duration: 5)
        
        player.run(action)
        player.run(changeSize)
        player.run(rotation)
        
        //setupChart()
        
        nl()
                    
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView

        self.removeGraph()
        scoresShown = false
        //self.mask.removeFromSuperview()
        self.playersPoints.removeFromSuperview()
        self.teamPoints.removeFromSuperview()
        self.exitButton.alpha = 0.0
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
    }
    
    func getQuestions() {
        print(currentSet)
        if ((currentSet?.contains(" (Science)")) != nil) {
            currentSet = currentSet?.replacingOccurrences(of: " (Science)", with: "")
            currentSet = currentSet?.replacingOccurrences(of: "HS - ", with: "")
        }
        print("whats good")
        print(incorrectCorrectQuestionsDictionary)
        print(UserDefaults.standard.stringArray(forKey: "incorrectCorrectQuestions-\(currentSet)"))
        
        let ref = questionRef.reference(withPath: "Sets/" + currentSet! + "/")
        
        ref.observeSingleEvent(of: .value) { [self] snapshot in
             // I got the expected number of items
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                let category = String(rest.key.split(separator: " ")[0])
                
                //print(UserDefaults.standard.object(forKey: "incorrectCorrectQuestions-\(currentSet)"))
                var createFirstTimeUserDefault: Bool?
                if UserDefaults.standard.stringArray(forKey: "incorrectCorrectQuestions-\(currentSet)") == nil {
                    createFirstTimeUserDefault = true
                } else {
                    //self.incorrectCorrectQuestionsDictionary = UserDefaults.standard.stringArray(forKey: "incorrectCorrectQuestions-\(currentSet)")
                    createFirstTimeUserDefault = false
                }
                
                if settingsArray != nil {
                    if settingsArray.values.contains(true) {
                        for setting in settingsArray {
                                
                            if (setting.key, setting.value) == (category.lowercased(), true) {
                                    
                                //self.questions.append(rest.key)
                                
                                if createFirstTimeUserDefault == true {
                                    self.incorrectCorrectQuestionsDictionary[rest.key] = "unseen"
                                    UserDefaults.standard.synchronize()
                                    if var answer = rest.value as? String {
                                        self.questions.append(rest.key)
                                        answer = answer.replacingOccurrences(of: "ANSWER: ", with: "").lowercased()
                                        self.answers.append(answer)
                                    }
                                } else {
                                    if unseen == "false" {
                                        if self.incorrectCorrectQuestionsDictionary[rest.key] == "incorrect" {
                                            if var answer = rest.value as? String {
                                                self.questions.append(rest.key)
                                                answer = answer.replacingOccurrences(of: "ANSWER: ", with: "").lowercased()
                                                self.answers.append(answer)
                                            }
                                        }
                                    } else if unseen == "true" {
                                        if self.incorrectCorrectQuestionsDictionary[rest.key] == "unseen" {
                                            if var answer = rest.value as? String {
                                                self.questions.append(rest.key)
                                                answer = answer.replacingOccurrences(of: "ANSWER: ", with: "").lowercased()
                                                self.answers.append(answer)
                                            }
                                        }
                                    } else if unseen == nil || unseen == "nil" {
                                        if var answer = rest.value as? String {
                                            self.questions.append(rest.key)
                                            answer = answer.replacingOccurrences(of: "ANSWER: ", with: "").lowercased()
                                            self.answers.append(answer)
                                        }
                                    }
                                }
                                if var answer = rest.value as? String {
                                    self.questions.append(rest.key)
                                    answer = answer.replacingOccurrences(of: "ANSWER: ", with: "").lowercased()
                                    self.answers.append(answer)
                                }
                            }
                        }
                    } else {
                        if createFirstTimeUserDefault == true {
                            self.incorrectCorrectQuestionsDictionary[rest.key] = "unseen"
                            UserDefaults.standard.synchronize()
                        }
                        if var answer = rest.value as? String {
                            self.questions.append(rest.key)
                            answer = answer.replacingOccurrences(of: "ANSWER: ", with: "").lowercased()
                            self.answers.append(answer)
                        }
                    }
                } else {
                    if createFirstTimeUserDefault == true {
                        self.incorrectCorrectQuestionsDictionary[rest.key] = "unseen"
                        UserDefaults.standard.synchronize()
                    }
                    if var answer = rest.value as? String {
                        self.questions.append(rest.key)
                        answer = answer.replacingOccurrences(of: "ANSWER: ", with: "").lowercased()
                        self.answers.append(answer)
                    }
                }
            }
        }
        var shuffled_indices = self.questions.indices.shuffled()
        
        self.questions = shuffled_indices.map { self.questions[$0] }
        self.answers = shuffled_indices.map { self.answers[$0] }
        
    }
    
    func drawBgShape() {
        DispatchQueue.main.sync {
            bgShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: frame.size.width/8.3, y: 1.5 * frame.size.height/8), radius:
                                                frame.size.width/10, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
            bgShapeLayer.strokeColor = UIColor.gray.cgColor
            bgShapeLayer.fillColor = UIColor.clear.cgColor
            bgShapeLayer.lineWidth = 5
            bgShapeLayer.opacity = 0.0
            view!.layer.addSublayer(bgShapeLayer)
        }
    }
    
    func drawTimeLeftShape() {
        DispatchQueue.main.sync {
            timeLeftShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: frame.size.width/8.3, y: 1.5 * frame.size.height/8), radius:
                                                    frame.size.width/10, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
            timeLeftShapeLayer.strokeColor = UIColor(red: 128/255, green: 176/255, blue: 255/255, alpha: 1.0).cgColor
            timeLeftShapeLayer.fillColor = UIColor.clear.cgColor
            timeLeftShapeLayer.lineWidth = 5
            timeLeftShapeLayer.opacity = 0.0
            view!.layer.addSublayer(timeLeftShapeLayer)
        }
    }
    
    func getValidQuestions() {
        for (category, boolean) in settingsArray {
            for (idx, question) in self.questions.enumerated() {
                let cat = question.split(separator: " ")[0]
                if cat == category {
                    if boolean == true {
                        validQuestions.append(idx)
                    }
                }
            }
        }
    }
    
    func nl() {
        let flip = SKAction.scaleX(to: -2, duration: 0.2)
        let revflip = SKAction.scaleX(to: 2, duration: 0.2)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 7.0) {
            
            self.player.run(flip)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) { [self] in
            
                self.player.run(revflip)
                self.explanation.alpha = 0.0
                self.addChild(self.explanation)
                
                let fade = SKAction.fadeAlpha(to: 1.0, duration: 1.0)
                let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: 0.5)
                self.explanation.text = "Save Joe from the asteroids by answering the questions correctly!"
                self.explanation.fontColor = UIColor.black
                self.explanation.numberOfLines = 3
                explanation.horizontalAlignmentMode = .center
                explanation.verticalAlignmentMode = .top
                explanation.zPosition = 5.0
                explanation.position = CGPoint(x: frame.midX, y: 0.8525 * frame.size.height)
                explanation.preferredMaxLayoutWidth = frame.width/1.5
                
                explanation.run(fade)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) { [self] in
                    
                    explanation.run(fadeOut)
                    
                    if self.firstQuestion {
                        let move = SKAction.moveTo(x: frame.size.width/8, duration: 1.0)
                        self.player.run(move)
                        self.renderThoughtBubble()
                        self.renderScoreBubble()
                        self.renderNextAsteroid()
                        self.renderExitAsteroid()
                        assignNextQuestion = true
                    }
                    let queue = DispatchQueue(label: "game-loop")
                    queue.async {
                        while question_running {
                            while true {
                                if assignNextQuestion == true {
                                    assignNextQuestion = false
                                    waitingForAsteroidNextToBePressed = false
                                    questionLabel.removeFromParent()
                                    questionLabel.alpha = 0.0
                                    break
                                } else {
                                    
                                }
                            }
                            runTimer()

                            var random_choice = (0 ... self.questions.count - 1).randomElement()
                            
                            asteroidNext.texture = SKTexture(imageNamed: "asteroid_next")
                                        
                            self.genAnswerType(questionNumber: random_choice!)
                            self.renderQuestion(questionNumber: random_choice!)
                            
                                
                            while waiting_for_answer {
                                
                                self.wait_for_answer(questionNumber: random_choice!)
                                if self.got_correct_answer == true {
                                    
                                    self.removeEntities()
                                    self.got_correct_answer = false
                                    self.questionTime = self.nilChangeQuestionTime
                                    self.levelTimer.invalidate()
                                    
                                    incorrectCorrectQuestionsDictionary[self.questions[random_choice!]] = "correct"
                                    self.correctQuestions += 1
                                    
                                    
                                    UserDefaults.standard.setValue(incorrectCorrectQuestionsDictionary, forKey: "incorrectCorrectQuestions-\(currentSet)")
                                    UserDefaults.standard.synchronize()

                                    DispatchQueue.main.async {
                                    
                                        self.bgShapeLayer.removeFromSuperlayer()
                                        self.timeLeftShapeLayer.removeFromSuperlayer()
                                        self.bgShapeLayer = CAShapeLayer()
                                        self.timeLeftShapeLayer = CAShapeLayer()
                                    }
                                    
                                    displayGreeting()
                                    asteroidNext.texture = SKTexture(imageNamed:  "asteroid_green")
                                    
                                    sleep(UInt32(2))
                                    break
                                } else if self.got_incorrect_answer == true {
                                    
                                    self.removeEntities()
                                    self.questionTime = self.nilChangeQuestionTime
                                    self.got_no_answer = false
                                    self.levelTimer.invalidate()
                                    
                                    incorrectCorrectQuestionsDictionary[self.questions[random_choice!]] = "incorrect"
                                    
                                    self.incorrectQuestions += 1
                                    
                                    UserDefaults.standard.setValue(incorrectCorrectQuestionsDictionary, forKey: "incorrectCorrectQuestions-\(currentSet)")
                                    UserDefaults.standard.synchronize()
                                    
                                    DispatchQueue.main.async {
                                    
                                        self.bgShapeLayer.removeFromSuperlayer()
                                        self.timeLeftShapeLayer.removeFromSuperlayer()
                                        self.bgShapeLayer = CAShapeLayer()
                                        self.timeLeftShapeLayer = CAShapeLayer()
                                    }
                                    self.got_incorrect_answer = false
                                    
                                    var currentAnswer = self.answers[random_choice!]
                                    
                                    asteroidNext.texture = SKTexture(imageNamed:  "asteroid_green")
                                    
                                    displayCorrectAnswer(currentAnswer: currentAnswer)
                                    sleep(UInt32(2))
                                    break
                                    
                                } else if self.got_no_answer == true {
                                    
                                    incorrectCorrectQuestionsDictionary[self.questions[random_choice!]] = "incorrect"
                                    
                                    self.incorrectQuestions += 1
                                    
                                    UserDefaults.standard.setValue(incorrectCorrectQuestionsDictionary, forKey: "incorrectCorrectQuestions-\(currentSet)")
                                    UserDefaults.standard.synchronize()
                                    
                                    DispatchQueue.main.async {
                                    
                                        self.bgShapeLayer.removeFromSuperlayer()
                                        self.timeLeftShapeLayer.removeFromSuperlayer()
                                        self.bgShapeLayer = CAShapeLayer()
                                        self.timeLeftShapeLayer = CAShapeLayer()
                                    }
                                    
                                    
                                    if scoresShown == false {
                                        self.mask.backgroundColor = UIColor.black.withAlphaComponent(0.0)
                                        self.mask.removeFromSuperview()
                                    }
                                    let fade = SKAction.fadeAlpha(to: 0.0, duration: 1.0)
                                    
                                    self.removeEntities()
                                    self.questionTime = self.nilChangeQuestionTime
                                    self.got_no_answer = false
                                    self.levelTimer.invalidate()
                                    
                                    var currentAnswer = self.answers[random_choice!]
                                    
                                    asteroidNext.texture = SKTexture(imageNamed:  "asteroid_green")
                                    
                                    displayCorrectAnswer(currentAnswer: currentAnswer)
                                    sleep(UInt32(2))
                                    break
                                }
                            }
                            waitingForAsteroidNextToBePressed = true
                        }
                    }
                }
            }
        }
    }
    private func renderNextAsteroid() {
        let rotate = SKAction.rotate(byAngle: .pi*100000000, duration: 100000000)
        asteroidNext.position = CGPoint(x: frame.width - 137*0.35, y:frame.height - 114*0.35)
        //asteroidNext.run(rotate)
        asteroidNext.zPosition = 18
        asteroidNext.size = CGSize(width: 137*0.7, height: 114*0.7)
        addChild(asteroidNext)
    }
    
    private func renderExitAsteroid() {
        let rotate = SKAction.rotate(byAngle: .pi*100000000, duration: 100000000)
        asteroidExit.position = CGPoint(x: frame.width - 137*0.35, y:frame.height * 1.2/3)
        //asteroidNext.run(rotate)
        asteroidExit.zPosition = 18
        asteroidExit.size = CGSize(width: 137*0.7, height: 114*0.7)
        addChild(asteroidExit)
    }
    
    private func displayGreeting() {
        
        questionLabel.text = "Nice! \nPress the next question button for another question!"
        
        questionLabel.fontColor = SKColor.black
        questionLabel.preferredMaxLayoutWidth = 435
        
        questionLabel.position = CGPoint(x: frame.size.width/3.7, y: 0.8525 * frame.size.height)
        
        questionLabel.horizontalAlignmentMode = .left
        questionLabel.verticalAlignmentMode = .top
        questionLabel.fontSize = 28
        
        questionLabel.preferredMaxLayoutWidth = 435
        
        questionLabel.zPosition = 1.5
        
        questionLabel.removeFromParent()
        addChild(questionLabel)
        
        let fade = SKAction.fadeAlpha(to: 1.0, duration: 1)
        questionLabel.run(fade)
    }
    
    private func displayCorrectAnswer(currentAnswer: String) {
        questionLabel.alpha = 0.0
        
        var answer = currentAnswer
        
        answer = answer.replacingOccurrences(of: "W ", with: "(W) ")
        answer = answer.replacingOccurrences(of: "X ", with: "(X) ")
        answer = answer.replacingOccurrences(of: "Y ", with: "(Y) ")
        answer = answer.replacingOccurrences(of: "Z ", with: "(Z) ")
        answer = answer.replacingOccurrences(of: "w ", with: "(w) ")
        answer = answer.replacingOccurrences(of: "x ", with: "(x) ")
        answer = answer.replacingOccurrences(of: "y ", with: "(y) ")
        answer = answer.replacingOccurrences(of: "z ", with: "(z) ")
        
        questionLabel.text = "Answer: " + answer + "\n\nPress the button to show the next question!"
        
        questionLabel.fontColor = SKColor.black
        questionLabel.preferredMaxLayoutWidth = 435
        
        questionLabel.position = CGPoint(x: frame.size.width/3.7, y: 0.8525 * frame.size.height)
        
        questionLabel.horizontalAlignmentMode = .left
        questionLabel.verticalAlignmentMode = .top
        questionLabel.fontSize = 28
        
        questionLabel.preferredMaxLayoutWidth = 435
        
        questionLabel.zPosition = 1.5
        
        questionLabel.removeFromParent()
        addChild(questionLabel)
        
        var currentQuestion = answer
        
        currentQuestion = currentQuestion.replacingOccurrences(of: "W ", with: "W) ")
        currentQuestion = currentQuestion.replacingOccurrences(of: "X ", with: "X) ")
        currentQuestion = currentQuestion.replacingOccurrences(of: "Y ", with: "Y) ")
        currentQuestion = currentQuestion.replacingOccurrences(of: "Z ", with: "Z) ")
        
        let fade = SKAction.fadeAlpha(to: 1.0, duration: 1)
        questionLabel.run(fade)
    }
    
    func renderQuestion(questionNumber: Int) {
        
        var currentQuestion = self.questions[questionNumber]
        print(currentQuestion, self.answers[questionNumber])
        
        //questionLabel.text = currentQuestion as! String

        questionLabel.numberOfLines = Int(round(Double((currentQuestion as! String).count / 35)))
        //print(Int(round(Double((currentQuestion as! String).count / 30))) - 1)
        questionLabel.horizontalAlignmentMode = .left
        questionLabel.verticalAlignmentMode = .top
        questionLabel.fontSize = 18
        //if Int(round(Double((currentQuestion as! String).count / 30))) > 4 {
        questionLabel.fontSize = CGFloat(29 - Int(round(Double((currentQuestion as! String).count / 35))))
        //}
        questionLabel.fontColor = SKColor.black
        questionLabel.preferredMaxLayoutWidth = 435
        
        questionLabel.position = CGPoint(x: frame.size.width/3.7, y: 0.8725 * frame.size.height)
        
        questionLabel.zPosition = 1.5
        
        //questionLabel.center = CGPoint(x: frame.midX, y: frame.midY + frame.size.height/4)
        questionLabel.alpha = 1.0
        questionLabel.removeFromParent()
        addChild(questionLabel)
        
        currentQuestion = currentQuestion.replacingOccurrences(of: " W ", with: "\nW) ")
        currentQuestion = currentQuestion.replacingOccurrences(of: " X ", with: "\nX) ")
        currentQuestion = currentQuestion.replacingOccurrences(of: " Y ", with: "\nY) ")
        currentQuestion = currentQuestion.replacingOccurrences(of: " Z ", with: "\nZ) ")
        
        currentQuestion = currentQuestion.replacingOccurrences(of: "Short Answer ", with: "Short Answer\n")
        currentQuestion = currentQuestion.replacingOccurrences(of: "Multiple Choice", with: "Multiple Choice\n")
        
        questionLabel.setTextWithTypeAnimation(typedText: currentQuestion as! String)
    }
    
    func removeEntities() {
        let fade = SKAction.fadeAlpha(to: 0.0, duration: 1.0)
        let sequence = SKAction.sequence([fade])
        
        if multipleChoice {
            
            asteroidA.run(sequence)
            asteroidB.run(sequence)
            asteroidC.run(sequence)
            asteroidD.run(sequence)
            questionLabel.run(sequence)
            //questionLabel.removeAllActions()
            
        } else {
            
            asteroidBuzzer.run(sequence)
            questionLabel.run(sequence)
            DispatchQueue.main.async { [self] in
                enterShortAnswer.resignFirstResponder()
                enterShortAnswer.removeFromSuperview()
            }
        }
        print("finished removing")
    }
    
    func wait_for_answer(questionNumber: Int) {
        let currentAnswer = self.answers[questionNumber]
        //print(currentAnswer)
        if self.answered != "" {
            if multipleChoice {

                if currentAnswer.contains(self.answered.lowercased()) {
                    
                    runCorrectAnimation()
                    self.got_correct_answer = true
                    self.answered = ""
                } else {
                    
                    runIncorrectAnimation()
                    self.got_incorrect_answer = true
                    self.answered = ""
                }
            } else {
                if currentAnswer.contains(self.answered.lowercased()) {
                    
                    runCorrectAnimation()
                    self.got_correct_answer = true
                    self.answered = ""
                } else {
                    
                    runIncorrectAnimation()
                    self.got_incorrect_answer = true
                    self.answered = ""
                }
            }
        }
    }
    
    func runIncorrectAnimation() {
        DispatchQueue.main.sync {
            UIView.animate(withDuration: 0.25, animations: {
                self.mask.backgroundColor = UIColor.black.withAlphaComponent(0.85)
                self.view!.addSubview(self.mask)
                if self.multipleChoice == false {
                    self.enterShortAnswer.alpha = 0.0
                }
            })
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 65))
            
            label.center = CGPoint(x: view!.frame.midX, y: view!.frame.midY)
            
            label.textAlignment = .center
            
            label.text = "INCORRECT"
            label.textColor = UIColor.red
            label.font = UIFont(name: "Peepo", size: 65)

            //incorrect_label.fontSize = 65
            
            //incorrect_label.position = CGPoint(x: frame.midX, y: frame.midY)
            //incorrect_label.zPosition = 3.0
            
            self.mask.addSubview(label)
            
        
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
                UIView.animate(withDuration: 0.25, animations: {
                    self.mask.backgroundColor = UIColor.black.withAlphaComponent(0.0)
                    self.mask.removeFromSuperview()
                    label.alpha = 0.0
                })
                //self.mask.removeFromSuperview()
            }
        }
    }
    
    func runCorrectAnimation() {
        DispatchQueue.main.sync {
            UIView.animate(withDuration: 0.25, animations: {
                self.mask.backgroundColor = UIColor.black.withAlphaComponent(0.85)
                self.view!.addSubview(self.mask)
            })
            
            let fade = SKAction.fadeAlpha(to: 1.0, duration: 1.0)
            
            let gif = (try? UIImage(gifName: "checkmark"))!
            
            let imageview = UIImageView(gifImage: gif, loopCount: 2) // Will loop 3 times
            imageview.frame = CGRect(x: view!.frame.midX-100, y: view!.frame.midY-75, width: 200, height: 150)
            //imageview.frame = view!.bounds
            view!.addSubview(imageview)
            
            personal_score += 10
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
                imageview.removeFromSuperview()
                self.mask.backgroundColor = UIColor.black.withAlphaComponent(0.0)
                self.mask.removeFromSuperview()
            }
        }
    }
    
    func runTimer() {
        timeLeft = questionTime!
        drawBgShape()
        drawTimeLeftShape()
        // here you define the fromValue, toValue and duration of your animation
        strokeIt.fromValue = 0
        strokeIt.toValue = 1
        strokeIt.duration = timeLeft
        // add the animation to your timeLeftShapeLayer
        timeLeftShapeLayer.add(strokeIt, forKey: nil)
        // define the future end time by adding the timeLeft to now Date()
        endTime = Date().addingTimeInterval(timeLeft)

        self.timer.position = CGPoint(x: frame.size.width/8, y: 6 * frame.size.height/8)
        self.timer.zPosition = 1.0
        self.timer.removeFromParent()
        self.timer.fontSize = 65
        addChild(self.timer)
        
        //var startTime = NSDate.timeIntervalSinceReferenceDate
        DispatchQueue.main.async { [self] in
            self.levelTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(levelCountdown(_:)), userInfo: nil, repeats: true)
        }
        //Selecto
        //self.timer.text = String(questionTime)
    }
    @objc func levelCountdown(_ timer: Timer) {
        questionTime = questionTime! - 0.1
        self.timer.text = String(questionTime!.rounded(toPlaces: 1))
        timeLeft = endTime?.timeIntervalSinceNow ?? 0
        if questionTime!.rounded(toPlaces: 1) < 0.0 {
            self.timer.text = String(0.0)
            self.got_no_answer = true
        }
    }
    
    func genAnswerType(questionNumber: Int) {
        
        var currentQuestion = self.questions[questionNumber]
        self.receiveAnswers = true
        
        if currentQuestion.contains("Short") {
            
            self.multipleChoice = false
            self.createBuzzer()
        } else if currentQuestion.contains("Multiple Choice") {
            
            self.multipleChoice = true
            self.createAsteroids()
            
        }
    }
    
    func determineTextSpeed(lines: Int) -> Int {
        
        if lines > 9 {
            return 1
        } else {
            return 10-lines
        }
    }
    
    func renderThoughtBubble() {
        
        //var image = SKSpriteNode(imageNamed: "thought.png")
        image.zPosition = 1.0
        image.position = CGPoint(x: frame.size.width/1.65 -  frame.size.width/32, y: frame.size.height/1.95)
        image.size.height = image.size.height * 2.6
        image.size.width = image.size.width * 2.75
        
        //mage
        image.alpha = 0.0
    
        addChild(image)
        
        let fade = SKAction.fadeAlpha(to: 1.0, duration: 1.0)
        
        image.run(fade)
    }
    
    func renderBackground() {
        
        background.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        background.size = frame.size
        addChild(background)
    }
    
    func renderScoreBubble() {
        
        asteroidScore.texture = SKTexture(imageNamed: "asteroid_score")
        asteroidScore.name = "asteroidScore"
        asteroidScore.size = CGSize(width: 137*0.7, height: 114*0.7)
        asteroidScore.position = CGPoint(x: frame.size.width/8, y: frame.midY)
        asteroidScore.zPosition = 1.0
        
        asteroidScore.alpha = 0.0
        
        self.addChild(asteroidScore)
        asteroidScore.run(SKAction.fadeAlpha(to: 1.0, duration: 1.0))
    }
    
    func createBuzzer() {
        
        asteroidBuzzer.texture = SKTexture(imageNamed: "asteroid_buzzer")
        asteroidBuzzer.name = "asteroidBuzzer"
        asteroidBuzzer.size = CGSize(width: 137*0.7, height: 114*0.7)
        
        let heights = frame.height/8
        asteroidBuzzer.position = CGPoint(x: self.width!-2.75*self.width!/7, y: heights)
        asteroidBuzzer.zPosition = 1.0
        
        asteroidBuzzer.alpha = 0.0
        
        let rotate = SKAction.rotate(byAngle: .pi*4, duration: self.questionTime!)
        let fade = SKAction.fadeAlpha(to: 1.0, duration: 1.0)
        
        if first_asteroid_buzzer_render == true {
            self.addChild(asteroidBuzzer)
            first_asteroid_buzzer_render = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            
            self.asteroidBuzzer.run(rotate)
            self.asteroidBuzzer.run(fade)
        }
    }
    
    func createAsteroids() {
        
        asteroidA.texture = SKTexture(imageNamed: "AsteriodW")
        asteroidB.texture = SKTexture(imageNamed: "AsteroidX")
        asteroidC.texture = SKTexture(imageNamed: "AsteroidY")
        asteroidD.texture = SKTexture(imageNamed: "AsteroidZ")
        
        asteroidA.name = "W"
        asteroidB.name = "X"
        asteroidC.name = "Y"
        asteroidD.name = "Z"
        
        asteroidA.size = CGSize(width: 102, height: 85)
        asteroidB.size = CGSize(width: 102, height: 85)
        asteroidC.size = CGSize(width: 102, height: 85)
        asteroidD.size = CGSize(width: 102, height: 85)
        
        let heights = frame.size.height/8
        
        asteroidA.position = CGPoint(x: self.width!-4.25*self.width!/7, y: heights)
        asteroidB.position = CGPoint(x: self.width!-3.25*self.width!/7, y: heights)
        asteroidC.position = CGPoint(x: self.width!-2.25*self.width!/7, y: heights)
        asteroidD.position = CGPoint(x: self.width!-1.25*self.width!/7, y: heights)
        
        let rotate = SKAction.rotate(byAngle: .pi*4, duration: self.questionTime!)
        
        asteroidA.alpha = 0.0
        asteroidB.alpha = 0.0
        asteroidC.alpha = 0.0
        asteroidD.alpha = 0.0
        
        asteroidA.zPosition = 1.0
        asteroidB.zPosition = 1.0
        asteroidC.zPosition = 1.0
        asteroidD.zPosition = 1.0
        
        if first_asteroid_render == true {
        
            self.addChild(asteroidA)
            self.addChild(asteroidB)
            self.addChild(asteroidC)
            self.addChild(asteroidD)
            
            first_asteroid_render = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            
            let fadeA = SKAction.fadeAlpha(to: 1.0, duration: 1.0)
            let fadeB = SKAction.fadeAlpha(to: 1.0, duration: 1.0)
            let fadeC = SKAction.fadeAlpha(to: 1.0, duration: 1.0)
            let fadeD = SKAction.fadeAlpha(to: 1.0, duration: 1.0)
            
            self.asteroidA.run(fadeA)
            self.asteroidB.run(fadeB)
            self.asteroidC.run(fadeC)
            self.asteroidD.run(fadeD)
            
            self.asteroidA.run(rotate)
            self.asteroidB.run(rotate)
            self.asteroidC.run(rotate)
            self.asteroidD.run(rotate)
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        let touchedNode = self.atPoint(pos)
        print(touchedNode.name, pos)
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNodes = self.nodes(at: positionInScene)
        for touch in touchedNodes {
            let touchName = touch.name
            if (touchName != nil && touchName!.hasPrefix("pato_")) {
                touch.removeFromParent()
            }
            if scoresShown == false {
                if waitingForAsteroidNextToBePressed == false {
                    if receiveAnswers == true {
                        if (touchName != nil) && touchName != "asteroidScore" && touchName != "asteroidNext" && touchName != "asteroidExitScreen" {
                            if multipleChoice {
                                
                                self.answered = touchName!
                            } else {
                                if touchName == "asteroidBuzzer" {
                                    DispatchQueue.main.async {
                                        self.showShortAnswerAlert()
                                    }
                                }
                            }
                        }
                    }
                    if touchName == "asteroidScore" {
                        //DispatchQueue.main.async {
                        //    self.showGraphs()
                        //}
                    }
                } else {
                    if touchName == "asteroidNext" {
                        waitingForAsteroidNextToBePressed = false
                        assignNextQuestion = true
                    }
                }
                if touchName == "asteroidExitScreen" {
                    let val = correctQuestions + incorrectQuestions
                    
                    self.percentage = Double((val/self.questions.count)*100)
                    print(self.percentage)
                    self.EXITGAME = true
                }
                
            } else {
                if touchName == "asteroidExit" {
                    self.removeGraph()
                    //self.mask.removeFromSuperview()
                    self.playersPoints.removeFromSuperview()
                    self.teamPoints.removeFromSuperview()
                    self.exitButton.alpha = 0.0
                }
            }
            // 334, 188 - 572, 188
        }
    }
    
    func showGraphs() {
        UIView.animate(withDuration: 0.25, animations: {
            self.mask.backgroundColor = UIColor.black.withAlphaComponent(0.85)
            self.view!.addSubview(self.mask)
        })
        
        view!.addSubview(playersPoints)
        view!.addSubview(teamPoints)
        self.exitButton.alpha = 1.0
    
        view!.addSubview(exitButton)
        
        scoresShown = true
    }
    
    func removeGraph() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.mask.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.mask.removeFromSuperview()
        }
    }
    
    func showShortAnswerAlert() {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.mask.backgroundColor = UIColor.black.withAlphaComponent(0.85)
            self.view!.addSubview(self.mask)
        })
            
        textBubble.center = CGPoint(x: view!.frame.midX, y: view!.frame.midY)
        textBubble.frame.size.width = frame.size.width/1.5
        textBubble.frame.size.height = frame.size.height
        //mage
        //self.mask.addSubview(textBubble)
        var img = try! UIImage(imageName: "thought2.png")
        //img = img?.resized(to: CGSize(width: frame.size.width/1.5, height: frame.size.height)
        enterShortAnswer.addTarget(self, action: #selector(enterPressed), for: .editingDidEndOnExit)
        enterShortAnswer.alpha = 1.0
        enterShortAnswer.text = ""
        
        enterShortAnswer.background = img
        enterShortAnswer.textAlignment = .center
        enterShortAnswer.adjustsFontSizeToFitWidth = true
        enterShortAnswer.center = CGPoint(x: view!.frame.midX, y: view!.frame.midY)
        self.enterShortAnswer.alpha = 1.0
        //enterShortAnswer.background!.size = CGSize(width: frame.size.width/1.5, height: frame.size.height)
        enterShortAnswer.font = UIFont(name: "Peepo", size: 25)
        
        self.mask.addSubview(enterShortAnswer)
    }
    
    @objc func enterPressed() {
        //do something with typed text if needed
        enterShortAnswer.resignFirstResponder()
        self.answered = enterShortAnswer.text!
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
extension SKLabelNode {
    func setTextWithTypeAnimation(typedText: String, characterDelay: TimeInterval = 0.5) {
        text = ""
        var writingTask: DispatchWorkItem?
        writingTask = DispatchWorkItem { [weak weakSelf = self] in
            for character in typedText {
                DispatchQueue.main.async {
                    weakSelf?.text!.append(character)
                }
                Thread.sleep(forTimeInterval: characterDelay/100)
            }
        }

        if let task = writingTask {
            let queue = DispatchQueue(label: "typespeed", qos: DispatchQoS.userInteractive)
            queue.asyncAfter(deadline: .now() + 0.05, execute: task)
        }
    }

}
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
extension BinaryInteger {
    var degreesToRadians: CGFloat { CGFloat(self) * .pi / 180 }
}
extension FloatingPoint {
    var degreesToRadians: Self { self * .pi / 180 }
    var radiansToDegrees: Self { self * 180 / .pi }
}
extension NSMutableAttributedString {

    func setColor(color: UIColor, forText stringValue: String) {
        let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }

}
