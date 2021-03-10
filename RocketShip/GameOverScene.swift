//
//  GameOverScene.swift
//  RocketShip
//
//  Created by Josh Manik on 10/03/2021.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene{
    
    var NewHighScore = Bool()
    
    let restartLabel = SKLabelNode(fontNamed: "ADAM.CGPRO")

    
    override func didMove(to view: SKView) {
        
        let backdrop = SKSpriteNode(imageNamed: "background")
        backdrop.position = CGPoint(x: self.size.width/2, y:self.size.height/2)
        backdrop.zPosition = 0
        self.addChild(backdrop)
        
        let GameOverLabel = SKLabelNode(fontNamed: "ADAM.CGPRO")
        GameOverLabel.text = "Game Over!"
        GameOverLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.7)
        GameOverLabel.zPosition = 1
        GameOverLabel.fontSize = 120
        GameOverLabel.fontColor = SKColor.white
        self.addChild(GameOverLabel)
        
        let scoreLabel = SKLabelNode(fontNamed: "ADAM.CGPRO")
        scoreLabel.text = "Score: \(userScore)"
        scoreLabel.fontColor = SKColor.white
        scoreLabel.fontSize = 100
        scoreLabel.zPosition = 1
        scoreLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.6)
        self.addChild(scoreLabel)
        
        let defaults = UserDefaults()
        var highscore = defaults.integer(forKey: "highscore")
        
        if userScore > highscore{
            defaults.setValue(userScore, forKey: "highscore")
            highscore = userScore
            NewHighScore = true
        }else{
            NewHighScore = false
        }
        
        let HighScoreLabel = SKLabelNode(fontNamed: "ADAM.CGPRO")
        
        if NewHighScore == true{
            HighScoreLabel.text = "New High Score! : \(highscore)"
            HighScoreLabel.fontSize = 70
        }else{
            HighScoreLabel.text = "High Score: \(highscore)"
            HighScoreLabel.fontSize = 100
        }
        HighScoreLabel.fontColor = SKColor.white
        HighScoreLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        HighScoreLabel.zPosition = 1
        self.addChild(HighScoreLabel)
        
        restartLabel.text = "Restart"
        restartLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.3)
        restartLabel.zPosition = 1
        restartLabel.fontSize = 70
        self.addChild(restartLabel)
        
        
        
    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
            let pointTouched = touch.location(in: self)
            
            if restartLabel.contains(pointTouched){
                let destination = GameScene(size: self.size)
                destination.scaleMode = self.scaleMode
                let transition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(destination, transition: transition)
            }
        }
        
    }
}
