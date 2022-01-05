//
//  Game.swift
//  1-Navigation Controller
//
//  Created by Ethan Nguyen on 26/4/21.
//

import Foundation
import UIKit
class Game {
    let bubbleSize = Bubble().bubbleSize;
    var listBubble: [String: Bubble] = [:]
    var arrayBubble: [Bubble] = []
    var counter:Int = 0
    var score: Int = 0
    var playerName: String = ""
    var remainingTime: Int = 0
    var timer = Timer()
    var generateBubbleTimer = Timer()
    var maxBubbles: Int = 1
    var lastPoppedBubbleColor: UIColor? = nil
    
    //Check if position of new bubble overlapped with otherss
    func checkOverlapped(newBubble: Bubble) -> Bool{
        let filtered = listBubble.filter { abs($0.value.xPosition - newBubble.xPosition) <= bubbleSize && abs($0.value.yPosition  - newBubble.yPosition) <= bubbleSize }
        if (filtered.isEmpty) {return false} else {return true}
    }
    func addBubble(newBubble: Bubble) {
        listBubble[newBubble.id] = newBubble
        arrayBubble.append(newBubble)
    }
    func removeBubble(removeBubble: Bubble) {
        listBubble.removeValue(forKey: removeBubble.id)
        let removeIdx = arrayBubble.firstIndex(of: removeBubble) ?? -1
        if removeIdx != -1 {arrayBubble.remove(at: removeIdx)}
    }
    func addScore(addedScore: Int) {
        self.score += addedScore
    }
    func isFullBubbles() -> Bool {
        return !(listBubble.count < maxBubbles)
    }
    func setLastPopBubbleColor(color: UIColor) {
        self.lastPoppedBubbleColor = color
    }
    func getRandomRemoveBubbles() -> [Bubble] {
        let numOfRemoveBubbles = Int.random(in: 0...Int(self.listBubble.count / 2))
        return Array(arrayBubble.choose(numOfRemoveBubbles))
    }
}
extension Collection {
    func choose(_ n: Int) -> ArraySlice<Element> { shuffled().prefix(n) }
}
