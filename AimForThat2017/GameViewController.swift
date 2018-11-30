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
    
    //MARK: - Global Variables
    
    var targetValue: Int = 0
    
    //MARK: - Life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        starNewRound()
    }
    
    //MARK: - Actions
    
    @IBAction func showAlert() {
        let message = """
        El valor del slider es \(lroundf(slider.value))
        El valor del objetivo es \(targetValue)
        """
        let alert = UIAlertController(title: "Hola Mundo", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Genial!", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
        starNewRound()
    }
    
    @IBAction func sliderMoved(_ sender: UISlider) {
    }
    
    //MARK: - Custom Methods
    
    fileprivate func generateRandomNumber() -> Int {
        return (1 + Int(arc4random_uniform(100)))
    }

    fileprivate func resetSliderStatus() {
        slider.value = Float((1 + Int(arc4random_uniform(100))))
    }
    
    fileprivate func starNewRound() {
        targetValue = generateRandomNumber()
        targetLabel.text = String(targetValue)
        resetSliderStatus()
    }
}
