//
//  HomeScreen.swift
//  RocketShip
//
//  Created by Josh Manik on 17/03/2021.
//

import Foundation
import SpriteKit
import GameKit


class RocketShipHomeScreen: SKScene , GKGameCenterControllerDelegate{
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    
    var BackgroundAnimation: Timer!
    let background = SKSpriteNode(imageNamed: "glitter-universe-1-1")
    var ticker = 0
    let localPlayer = GKLocalPlayer.local
    var GameCenterPlayer = true


    
    override func didMove(to view: SKView) {
        
        
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.size.width = self.size.width
        background.size.height = self.size.height
        background.zPosition = 0
        self.addChild(background)
        
        let GameName = SKLabelNode(fontNamed: "ADAM.CGPRO")
        GameName.text = "Interstellar Raider"
        GameName.fontSize = 80
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
        
        
        let Leaderboards = SKLabelNode(fontNamed: "ADAM.CGPRO")
        Leaderboards.text = "Leaderboards"
        Leaderboards.fontSize = 70
        Leaderboards.fontColor = SKColor.white
        Leaderboards.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.2)
        Leaderboards.zPosition = 1
        Leaderboards.name = "Leaderboards"
        self.addChild(Leaderboards)
        BackgroundAnimation = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(UpdateBackgroundTexture), userInfo: nil, repeats: true)
        authPlayer()
        
    }
    
    @objc func UpdateBackgroundTexture(){
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
            let pointOfTouch = touch.location(in: self)
            let nodeTapped = atPoint(pointOfTouch)
            
            
            if nodeTapped.name == "StartButton"{
                let destination = GameScene(size: self.size)
                destination.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.4)
                self.view!.presentScene(destination, transition: myTransition)
            }
            
            if nodeTapped.name == "Leaderboards"{
                moveToUIViewController(storyBoardId: "leaderboard")
            }
        }
    }
    
    fileprivate func moveToUIViewController(storyBoardId: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: storyBoardId)
        vc.view.frame = self.frame
        vc.view.layoutIfNeeded()

        self.view?.window?.rootViewController?.present(vc, animated: true, completion: nil)
    }
    
    func authPlayer(){
        localPlayer.authenticateHandler = {
            (view, Error) in
            // if they accept show the view
            if view != nil {self.view?.window?.rootViewController?.present(view!, animated: true, completion: nil)}
            // if they dont dont show view and log they are not in gamecenter
            else {self.GameCenterPlayer = false}
        }}

    
    
}

