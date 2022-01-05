//
//  GameViewController.swift
//  1-Navigation Controller
//
//  Created by Ethan Nguyen
//

import UIKit
import Foundation

import AVFoundation
var audioPlayer: AVAudioPlayer!

class GameViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var scoreValueLabel: UILabel!
    @IBOutlet weak var GameView: UIView!
    var game = Game()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        nameLabel.text = game.playerName
        remainingTimeLabel.text = String(game.remainingTime)
        // active timer, to count down game time
        game.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            timer in
            self.counting()
        }
        //timer for generate a bubble
        game.generateBubbleTimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) {
            timer in
            self.generateBubble()
        }
    }
    
    @objc func counting() {
        game.remainingTime -= 1
        remainingTimeLabel.text = String(game.remainingTime)
        //Random remove bubbles and add new bubbles to random positions
        let listOfRemovesBubble = game.getRandomRemoveBubbles()
        if (listOfRemovesBubble.count > 0) {
            _ = listOfRemovesBubble.map{
                game.removeBubble(removeBubble: $0)
                removeBubbleFromGamePlay(bubble: $0)
            }
            for _ in 1...listOfRemovesBubble.count {
                generateBubble()
            }
        }
        
        //Actions when time end
        if game.remainingTime == 0 {
            game.timer.invalidate()
            //Read HighScore and write from highscore.txt
            var highscores: [[String]] = []
            if let path = Bundle.main.path(forResource: "highscore", ofType: "txt") {
             
                do {
                    let data = try String(contentsOfFile: path, encoding: .utf8)
                    let highScoreList = data.split(separator: ":")
                    for item in highScoreList{
                        let name = String(item.split(separator: "|")[0])
                        let score = String(item.split(separator: "|")[1])
                        highscores.append([name, score])
                    }
                    //Find if player exists in high score file
                    let playerHistoryScore = highscores.filter{
                        $0[0] == game.playerName
                    }
                    //not found add a new line
                    if playerHistoryScore.count == 0 {
                        highscores.append([game.playerName, String(game.score)])
                    }
                    else {
                        //Check if new score is higher than the old one and write to file
                        if Int(playerHistoryScore[0][1])! < game.score {
                            highscores = highscores.filter{$0[0] != game.playerName}
                            highscores.append([game.playerName, String(game.score)])
                        }
                    }
                    //Writing to files
                    var strToWrite: String = ""
                    for item in highscores {
                        if (strToWrite != "") {
                            strToWrite += ":"
                        }
                        strToWrite += item[0] + "|" + item[1]
                        let fileURL = URL(fileURLWithPath: path)
                        do {
                            try strToWrite.write(to: fileURL, atomically: false, encoding: .utf8)
                        }
                        catch {/* error handling here */}
                    }
                }
                catch {print(error)}
            }
            UserDefaults.standard.set(game.score, forKey: "yourScore")
            UserDefaults.standard.set(game.playerName, forKey: "playerName")
            // show HighScore Screen
            let vc = storyboard?.instantiateViewController(identifier: "HighScoreViewController") as! HighScoreViewController
            self.navigationController?.pushViewController(vc, animated: true)
            vc.navigationItem.setHidesBackButton(true, animated: true)
        }
    }
    
    //Generate a bubble
    @objc func generateBubble() {
        if game.isFullBubbles() {
            return
        }
        var bubble = Bubble()
        let bubbleSize = bubble.bubbleSize
        bubble.setPosition(x: Int.random(in: bubbleSize...Int(GameView.bounds.width) - bubbleSize) , y: Int.random(in: bubbleSize...Int(GameView.bounds.height) - bubbleSize))
        while (game.checkOverlapped(newBubble: bubble) && game.remainingTime != 0) {
            bubble = Bubble()
            return
        }
        game.addBubble(newBubble: bubble)
        bubble.animation()
        bubble.addTarget(self, action: #selector(bubblePressed), for: .touchUpInside)
        self.GameView.addSubview(bubble)
    }
    
    @objc func removeBubbleFromGamePlay(bubble: Bubble) {
        //Animate removed bubble
        //set position where bubble will move to
        var xDisappear: Int = 0
        var yDisappear: Int = 0
        let removeStyle = Int.random(in: 1...4)
        switch removeStyle {
        case 1:
            xDisappear = bubble.xPosition + bubble.bubbleSize / 2
            yDisappear = Int(self.GameView.bounds.maxY) + 100
        case 2:
            xDisappear = bubble.xPosition + bubble.bubbleSize / 2
            yDisappear = -Int(self.GameView.bounds.maxY)
        case 3:
            xDisappear = -200
            yDisappear = bubble.yPosition + bubble.bubbleSize / 2
        case 4:
            xDisappear = Int(self.GameView.bounds.maxX) + 100
            yDisappear = bubble.yPosition + bubble.bubbleSize / 2
        default:
            xDisappear = 0
            yDisappear = 0
        }
        bubble.flash()
        //animation
        UIView.animateKeyframes(withDuration: 5,
                                delay: 0,
                                options: .calculationModeLinear,
                                animations: {
                                    UIView.addKeyframe(
                                        withRelativeStartTime: 0,
                                        relativeDuration: 0.05) {
                                        bubble.center = CGPoint(x: xDisappear, y: yDisappear)
                                    }
                                },
                                completion: {_ in bubble.removeFromSuperview()}
        )
    }
    
    //when a bubble is pressed
    @IBAction func bubblePressed(_ sender: UIButton) {
        let bubble = sender as? Bubble
        //play a pop sound
        let bubblePopSound = URL(fileURLWithPath: Bundle.main.path(forResource: "bubblepop", ofType: "mp3")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: bubblePopSound)
            audioPlayer.play()
        } catch {
            print(error)
        }
        //calculate score and display
        var scoreAchieved = bubble?.score ?? 0
        //if last bubble is same color, increase score
        if  (game.lastPoppedBubbleColor == bubble?.color) {
            scoreAchieved = Int(ceil(1.5 * Double(scoreAchieved)))
        }
        game.addScore(addedScore: Int(scoreAchieved))
        scoreValueLabel.text = String(game.score)
        //remove from bubble array and game play
        game.removeBubble(removeBubble:bubble!)
        removeBubbleFromGamePlay(bubble: bubble!)
        game.setLastPopBubbleColor(color: bubble!.color)
    }
}
