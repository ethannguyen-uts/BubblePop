//
//  HighScoreViewController.swift
//  1-Navigation Controller
//
//  Created by Ethan Nguyen
//

import UIKit

class HighScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        highscores.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = highScoreTableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.rankLabel.text = String(indexPath.row + 1)
        cell.nameLabel.text = highscores[indexPath.row][0]
        cell.scoreLabel.text = highscores[indexPath.row][1]
        return cell
    }
    @IBOutlet weak var highScoreTableView: UITableView!
    @IBOutlet weak var yourScoreLabel: UILabel!
    
    var highscores: [[String]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        highScoreTableView.register(nib, forCellReuseIdentifier: "TableViewCell")
        highScoreTableView.delegate = self
        highScoreTableView.dataSource = self
        var playerName = "player"
        if let pln =  UserDefaults.standard.value(forKey: "playerName") as? String {
            playerName = pln
        }
        if let item =  UserDefaults.standard.value(forKey: "yourScore") as? Int {
            yourScoreLabel.text =  "Congratulations, " + playerName + ". Your Score: " + String(item)
        } else {
            yourScoreLabel.text = ""
        }
        readHighScore()
    }
    //read high score from Txt File
    func readHighScore() {
        if let path = Bundle.main.path(forResource: "highscore", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let highScoreList = data.split(separator: ":")
                for item in highScoreList{
                    let name = String(item.split(separator: "|")[0])
                    let score = String(item.split(separator: "|")[1])
                    highscores.append([name, score])
                    highscores = highscores.sorted(by: { Int($0[1])! > Int($1[1])! })
                
                }
            }
            catch {print(error)}
            
        }
    }

    @IBAction func returnMainPage(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    

}


