//
//  GameOverScene.swift
//  RocketShip
//
//  Created by Josh Manik on 10/03/2021.
//

import Foundation
import SpriteKit
import GameKit


class GameOverScene: SKScene{
    
    var NewHighScore = Bool()
    
    let restartLabel = SKLabelNode(fontNamed: "ADAM.CGPRO")

    
    var BackgroundAnimation: Timer!
    let background = SKSpriteNode(imageNamed: "glitter-universe-1-1")
    var ticker = 0
    
    override func didMove(to view: SKView) {
        
        background.position = CGPoint(x: self.size.width/2, y:self.size.height/2)
        background.zPosition = 0
        background.size.width = self.size.width
        background.size.height = self.size.height
        self.addChild(background)
        
        BackgroundAnimation = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(UpdateBackgroundTexture), userInfo: nil, repeats: true)
        
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
            saveHigh(number: userScore)
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
    
    func saveHigh(number : Int){
        if GKLocalPlayer.local.isAuthenticated{
            let scoreReporter = GKScore(leaderboardIdentifier: "HighScores")
            scoreReporter.value = Int64(number)
            let ScoreArray : [GKScore] = [scoreReporter]
            GKScore.report(ScoreArray, withCompletionHandler: nil)

        }}
    
    @objc func UpdateBackgroundTexture(){
        print(ticker)
        if ticker == 0 {
            background.texture = SKTexture(imageNamed: "glitter-universe-1-1" )
            ticker = 1
        }else if ticker == 1{
            background.texture = SKTexture(imageNamed: "glitter-universe-1-2" )
            ticker = 2
        }else if ticker == 2{
            background.texture = SKTexture(imageNamed: "glitter-universe-1-3" )
            ticker = 3
        }else if ticker == 3{
            background.texture = SKTexture(imageNamed: "glitter-universe-1-4" )
            ticker = 4
        }else if ticker == 4{
            background.texture = SKTexture(imageNamed: "glitter-universe-1-5" )
            ticker = 5
        }else if ticker == 5{
            background.texture = SKTexture(imageNamed: "glitter-universe-1-6" )
            ticker = 6
        }else if ticker == 6{
            background.texture = SKTexture(imageNamed: "glitter-universe-1-7" )
            ticker = 7
        }else if ticker == 7{
            background.texture = SKTexture(imageNamed: "glitter-universe-1-8" )
            ticker = 8
        }else if ticker == 8{
            background.texture = SKTexture(imageNamed: "glitter-universe-1-9" )
            ticker = 9
        }else if ticker == 9{
            background.texture = SKTexture(imageNamed: "glitter-universe-1-10" )
            ticker = 10
        }else if ticker == 10{
            background.texture = SKTexture(imageNamed: "glitter-universe-1-11" )
            ticker = 11
        }else if ticker == 11{
            background.texture = SKTexture(imageNamed: "glitter-universe-1-12" )
            ticker = 12
        }else if ticker == 12{
            background.texture = SKTexture(imageNamed: "glitter-universe-1-13" )
            ticker = 13
        }else if ticker == 13{
            background.texture = SKTexture(imageNamed: "glitter-universe-1-14" )
            ticker = 14
        }else if ticker == 14{
            background.texture = SKTexture(imageNamed: "glitter-universe-1-15" )
            ticker = 15
        }else if ticker == 15{
            background.texture = SKTexture(imageNamed: "glitter-universe-1-16" )
            ticker = 16
        }else if ticker == 16{
            background.texture = SKTexture(imageNamed: "glitter-universe-1-17" )
            ticker = 17
        }else if ticker == 17{
            background.texture = SKTexture(imageNamed: "glitter-universe-1-18" )
            ticker = 18
        }else if ticker == 18{
            background.texture = SKTexture(imageNamed: "glitter-universe-1-19" )
            ticker = 19
        }else if ticker == 19{
            background.texture = SKTexture(imageNamed: "glitter-universe-1-20" )
            ticker = 20
        }else if ticker == 20{
            background.texture = SKTexture(imageNamed: "glitter-universe-1-21" )
            ticker = 21
        }else if ticker == 21{
            background.texture = SKTexture(imageNamed: "glitter-universe-1-22" )
            ticker = 22
        }else if ticker == 22{
            background.texture = SKTexture(imageNamed: "glitter-universe-1-23" )
            ticker = 23
        }else if ticker == 23{
            background.texture = SKTexture(imageNamed: "glitter-universe-1-24" )
            ticker = 24
        }else if ticker == 24{
            background.texture = SKTexture(imageNamed: "glitter-universe-1-25" )
            ticker = 25
        }else if ticker == 25{
            background.texture = SKTexture(imageNamed: "glitter-universe-1-26" )
            ticker = 0
        }
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
