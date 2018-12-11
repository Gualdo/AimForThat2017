//
//  ViewController.swift
//  AimForThat2017
//
//  Created by De La Cruz, Eduardo on 27/11/2018.
//  Copyright © 2018 De La Cruz, Eduardo. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    
    //MARK: - Global Variables
    
    var targetValue: Int = 0
    var round: Int = 1
    var score: Int = 0
    
    //MARK: - Life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSlider()
        resetGame()
    }
    
    //MARK: - Actions
    
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
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK!", style: .default, handler: { action in
             self.starNewRound()
        })
        alert.addAction(action)
        present(alert, animated: true)
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
        targetLabel.text = "\(targetValue)"
        scoreLabel.text = "\(score)"
        roundLabel.text = "\(round)"
    }
    
    fileprivate func starNewRound() {
        round += 1
        targetValue = generateRandomNumber()
        updateLabels()
        resetSliderStatus()    }
    
    fileprivate func resetGame() {
        score = 0
        round = 0
        starNewRound()
    }
}
