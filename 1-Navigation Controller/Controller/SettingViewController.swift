//
//  BlueViewController.swift
//  1-Navigation Controller
//
//  Created by Ethan.
//

import UIKit

class SettingViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var startGameBtn: UIButton!
    @IBOutlet weak var maxBubblesSlider: UISlider!
    @IBAction func maxBubblesSliderChange(_ sender: UISlider) {
        totalBubblesField.text = String(Int(sender.value)) + " bubbles"
    }
    @IBOutlet weak var timeSlider: UISlider!
    @IBAction func sliderChanged(_ sender: UISlider) {
        gameTimeField.text = String(Int(sender.value)) + " seconds"
    }
    @IBOutlet weak var gameTimeField: UILabel!
    @IBOutlet weak var totalBubblesField: UILabel!
    @IBOutlet weak var playerNameField: UITextField!
    
    @IBAction func changeNameField(_ sender: UIButton!) {
        if (playerNameField.text) != "" {
            startGameBtn.isUserInteractionEnabled = true
        } else {startGameBtn.isUserInteractionEnabled = false}
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        timeSlider.value = 60
        maxBubblesSlider.value = 15
        totalBubblesField.text =
            String(Int(maxBubblesSlider.value)) + " bubbles"
        startGameBtn.isUserInteractionEnabled = true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGame" {
            let VC = segue.destination as! GameViewController
            VC.game.playerName = nameTextField.text!
            VC.game.remainingTime = Int(timeSlider.value)
            VC.game.maxBubbles = Int(maxBubblesSlider.value)
        }
    }
}
