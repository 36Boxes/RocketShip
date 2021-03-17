//
//  HomeScreen.swift
//  RocketShip
//
//  Created by Josh Manik on 17/03/2021.
//

import Foundation
import SpriteKit


class RocketShipHomeScreen: SKScene{
    
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "BackgroundTest")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let GameName = SKLabelNode(fontNamed: "ADAM.CGPRO")
        GameName.text = "Rocket Ship"
        GameName.fontSize = 114
        GameName.fontColor = SKColor.white
        GameName.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.7)
        GameName.zPosition = 1
        self.addChild(GameName)
        
        
        
        let GameStart = SKLabelNode(fontNamed: "ADAM.CGPRO")
        GameStart.text = "Start"
        GameStart.fontSize = 70
        GameStart.fontColor = SKColor.white
        GameStart.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.4)
        GameStart.zPosition = 1
        GameStart.name = "StartButton"
        self.addChild(GameStart)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            let nodeTapped = atPoint(pointOfTouch)
            
            
            if nodeTapped.name == "StartButton"{
                let destination = GameScene(size: self.size)
                destination.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.4)
                self.view!.presentScene(destination, transition: myTransition)
            }
        }
    }
    
    
}
