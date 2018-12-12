//
//  ViewController.swift
//  AimForThat2017
//
//  Created by De La Cruz, Eduardo on 27/11/2018.
//  Copyright © 2018 De La Cruz, Eduardo. All rights reserved.
//

import UIKit
import QuartzCore

class GameViewController: UIViewController {
    
    enum RoundOrGame: Int {
        case Round
        case Game
    }
    
    //MARK: - Outlets
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var recordLabel: UILabel!
    
    //MARK: - Global Variables
    
    var targetValue: Int = 0
    var round: Int = 1
    var score: Int = 0
    var time: Int = 0
    var timer: Timer?
    var recordScore: Int = 0
    var backFromInfo: Bool = false
    var restoreType: RoundOrGame?
    
    //MARK: - Life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordScore = UserDefaults.standard.integer(forKey: "maxScore")
        setupSlider()
        resetGame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if backFromInfo {
            backFromInfo = false
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        }
    }
    
    //MARK: - Actions
    
    @IBAction func infoButtonPressed() {
        timer?.invalidate()
        backFromInfo = true
    }
    
    @IBAction func startNewGame() {
        resetGame()
    }
    
    @IBAction func showAlert() {
        let difference: Int = abs((getCurrentValue() - targetValue))
        var points: Int {
            switch difference {
            case 0:
                return Int(Float(100 - difference) * 10.0)
            case 1...5:
                return Int(Float(100 - difference) * 1.5)
            case 6...12:
                return Int(Float(100 - difference) * 1.2)
            default:
                return 100 - difference
            }
        }
        var title: String {
            switch difference {
            case 0:
                return "¡¡¡Puntuación perfecta!!!"
            case 1...5:
                return "Casi perfecto!!!"
            case 6...12:
                return "Te ha faltado poco!!!"
            default:
                return "Has ido lejos..."
            }
        }
        let message = "Has marcado \(points) puntos"
        restoreType = RoundOrGame.Round
        presentOkAlertAndStartNewRound(title: title, message: message)
        score += points
    }
    
    //MARK: - Custom Methods
    
    fileprivate func setupSlider() {
        let thumbImageNormal = UIImage(named: "SliderThumb-Normal")
        let thumbImageHighlighted = UIImage(named: "SliderThumb-Highlighted")
        let trackLeftImage = UIImage(named: "SliderTrackLeft")
        let trackRightImage = UIImage(named: "SliderTrackRight")
        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        let trackLeftResizable = trackLeftImage?.resizableImage(withCapInsets: insets)
        let trackRightResizable = trackRightImage?.resizableImage(withCapInsets: insets)
        
        slider.setThumbImage(thumbImageNormal, for: .normal)
        slider.setThumbImage(thumbImageHighlighted, for: .highlighted)
        slider.setMinimumTrackImage(trackLeftResizable, for: .normal)
        slider.setMaximumTrackImage(trackRightResizable, for: .normal)
    }
    
    fileprivate func getCurrentValue() -> Int {
        return lroundf(slider.value)
    }
    
    fileprivate func generateRandomNumber() -> Int {
        return (1 + Int(arc4random_uniform(100)))
    }

    fileprivate func resetSliderStatus() {
        slider.value = Float(generateRandomNumber())
    }
    
    fileprivate func updateLabels() {
        handleMaxScore()
        targetLabel.text = "\(targetValue)"
        scoreLabel.text = "\(score)"
        roundLabel.text = "\(round)"
        timeLabel.text = "\(time)"
        recordLabel.text = "\(recordScore)"
    }
    
    fileprivate func startNewRound() {
        round += 1
        targetValue = generateRandomNumber()
        updateLabels()
        resetSliderStatus()
        let transition = CATransition()
        transition.type = .fade
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        self.view.layer.add(transition, forKey: nil)
        
        if timer != nil {
            timer?.invalidate()
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
    }
    
    fileprivate func resetGame() {
        score = 0
        round = 0
        time = 5
        startNewRound()
    }
    
    @objc fileprivate func tick() {
        time -= 1
        timeLabel.text = "\(time)"
        
        if time <= 0 {
            timer?.invalidate()
            if let vC = self.presentedViewController {
                vC.dismiss(animated: true, completion: {
                    self.restoreType = RoundOrGame.Game
                    self.presentOkAlertAndStartNewRound(title: "Watch time!!!", message: "Your time has expired, go faster on the next time!!!")
                })
            } else {
                restoreType = RoundOrGame.Game
                presentOkAlertAndStartNewRound(title: "Watch time!!!", message: "Your time has expired, go faster on the next time!!!")
            }
        }
    }
    
    fileprivate func presentOkAlertAndStartNewRound(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK!", style: .default, handler: { action in
            if self.restoreType == RoundOrGame.Round {
                self.startNewRound()
            }
            if self.restoreType == RoundOrGame.Game {
                self.resetGame()
            }
        })
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    fileprivate func handleMaxScore() {
        let maxScore = UserDefaults.standard.integer(forKey: "maxScore")
        
        if maxScore < score {
            UserDefaults.standard.set(score, forKey: "maxScore")
            recordScore = score
        }
    }
}
