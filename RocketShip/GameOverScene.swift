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
    let homelabel = SKLabelNode(fontNamed: "ADAM.CGPRO")

    
    var BackgroundAnimation: Timer!
    let background = SKSpriteNode(imageNamed: "glitter-universe-1-1")
    var ticker = 0
    
    var BackgroundTextureAtlas = SKTextureAtlas()
    var BackgroundTextureArray: [SKTexture] = []
    
    var AsteroidTextureAtlas = SKTextureAtlas()
    var AsteroidTextureArray: [SKTexture] = []
    
    var EnemyTextureAtlas = SKTextureAtlas()
    var EnemyTextureArray: [SKTexture] = []
    
    var GoldAsteroidTextureAtlas = SKTextureAtlas()
    var GoldAsteroidTextureArray: [SKTexture] = []
    
    var BlueDiamondTextureAtlas = SKTextureAtlas()
    var BlueDiamondTextureArray: [SKTexture] = []
    
    var GreenDiamondTextureAtlas = SKTextureAtlas()
    var GreenDiamondTextureArray: [SKTexture] = []
    
    var PurpleDiamondTextureAtlas = SKTextureAtlas()
    var PurpleDiamondTextureArray: [SKTexture] = []
    
    var PlayerShipTextureAtlas = SKTextureAtlas()
    var PlayerShipTextureArray: [SKTexture] = []
    
    var PlayerShipBoostedTextureAtlas = SKTextureAtlas()
    var PlayerShipBoostedTextureArray: [SKTexture] = []
    
    var BoostCoinTextureAtlas = SKTextureAtlas()
    var BoostCoinTextureArray: [SKTexture] = []
    
    var XPCoinTextureAtlas = SKTextureAtlas()
    var XPCoinTextureArray: [SKTexture] = []
    
    let gameArea: CGRect
    
    override init(size: CGSize){
        
        // to have this work nicely on most devices i could maybe identify the device and then have the correct aspect ratio
        let maxAspectRatio: CGFloat = 19.5/9
        let gameAreaWidth = size.height / maxAspectRatio
        let margin = (size.width - gameAreaWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: gameAreaWidth, height: size.height)
        super.init(size:size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startNewLevel(){
        
        let spawn = SKAction.run(SpawnEnemy)
        let waitToSpawn = SKAction.wait(forDuration: 0.5)
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnLoop = SKAction.repeatForever(spawnSequence)
        self.run(spawnLoop, withKey: "SpawningEnemies")
    }
    
    override func didMove(to view: SKView) {
        
        background.position = CGPoint(x: self.size.width/2, y:self.size.height/2)
        background.zPosition = 0
        background.size.width = self.size.width
        background.size.height = self.size.height
        self.addChild(background)
        
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
        restartLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.4)
        restartLabel.zPosition = 1
        restartLabel.fontSize = 70
        self.addChild(restartLabel)
        
        homelabel.text = "Go Home"
        homelabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.2)
        homelabel.zPosition = 1
        homelabel.fontSize = 70
        self.addChild(homelabel)
        BackgroundTextureAtlas = SKTextureAtlas(named: "BackgroundImages.atlas")
        for p in 1...BackgroundTextureAtlas.textureNames.count{
            let texture = "glitter-universe-1-\(p).png"
            BackgroundTextureArray.append(SKTexture(imageNamed: texture))
        }
        
        let anim =  SKAction.animate(with: BackgroundTextureArray, timePerFrame: 0.02)
        let anim4eva = SKAction.repeatForever(anim)
        background.run(anim4eva, withKey: "StanBack")
        
        AsteroidTextureAtlas = SKTextureAtlas(named: "AsteroidSpin.atlas")
        PlayerShipTextureAtlas = SKTextureAtlas(named: "Boost.atlas")
        PlayerShipBoostedTextureAtlas = SKTextureAtlas(named: "Boost.atlas")
        BackgroundTextureAtlas = SKTextureAtlas(named: "BackgroundImages.atlas")
        GoldAsteroidTextureAtlas = SKTextureAtlas(named: "goldAsteroidSpin.atlas")
        BoostCoinTextureAtlas = SKTextureAtlas(named: "boostcoinspin.atlas")
        XPCoinTextureAtlas = SKTextureAtlas(named: "purplexp.atlas")
        PurpleDiamondTextureAtlas = SKTextureAtlas(named: "purpleDiamond.atlas")
        GreenDiamondTextureAtlas = SKTextureAtlas(named: "greenDiamond.atlas")
        BlueDiamondTextureAtlas = SKTextureAtlas(named: "blueDiamond.atlas")
        EnemyTextureAtlas = SKTextureAtlas(named: "Enemyflames.atlas")
        
        for i in 1...EnemyTextureAtlas.textureNames.count{
            let TexName = "E\(i).png"
            EnemyTextureArray.append(SKTexture(imageNamed: TexName))
        }
        
        for i in 1...AsteroidTextureAtlas.textureNames.count{
            let TexName = "A\(i)@0.5x.png"
            AsteroidTextureArray.append(SKTexture(imageNamed: TexName))
        }
        
        for n in 1...PlayerShipTextureAtlas.textureNames.count{
            let texture = "Boost\(n).png"
            PlayerShipTextureArray.append(SKTexture(imageNamed: texture))
        }
        
        for a in 1...PlayerShipBoostedTextureAtlas.textureNames.count{
            let texture = "Boost\(a).png"
            PlayerShipBoostedTextureArray.append(SKTexture(imageNamed: texture))
        }
        
        for a in 1...GoldAsteroidTextureAtlas.textureNames.count{
            let texture = "GA\(a).png"
            GoldAsteroidTextureArray.append(SKTexture(imageNamed: texture))
        }
        
        for a in 1...BoostCoinTextureAtlas.textureNames.count{
            let texture = "BoostCoin\(a).png"
            BoostCoinTextureArray.append(SKTexture(imageNamed: texture))
        }
        
        for a in 1...XPCoinTextureAtlas.textureNames.count{
            let texture = "XPP\(a).png"
            XPCoinTextureArray.append(SKTexture(imageNamed: texture))
        }
        
        for a in 1...PurpleDiamondTextureAtlas.textureNames.count{
            let texture = "Purple\(a).png"
            PurpleDiamondTextureArray.append(SKTexture(imageNamed: texture))
        }
        
        for a in 1...GreenDiamondTextureAtlas.textureNames.count{
            let texture = "Green\(a).png"
            GreenDiamondTextureArray.append(SKTexture(imageNamed: texture))
        }
        
        for a in 1...BlueDiamondTextureAtlas.textureNames.count{
            let texture = "Blue\(a).png"
            BlueDiamondTextureArray.append(SKTexture(imageNamed: texture))
        }
        
        for p in 1...BackgroundTextureAtlas.textureNames.count{
            let texture = "glitter-universe-1-\(p).png"
            BackgroundTextureArray.append(SKTexture(imageNamed: texture))
        }
        startNewLevel()
        
        
    }
    
    func saveHigh(number : Int){
        if GKLocalPlayer.local.isAuthenticated{
            let scoreReporter = GKScore(leaderboardIdentifier: "IR_Scores")
            scoreReporter.value = Int64(number)
            let ScoreArray : [GKScore] = [scoreReporter]
            GKScore.report(ScoreArray, withCompletionHandler: nil)

        }}
    

    func SpawnEnemy(){
        
        let randomXStart = CGFloat.random(in: gameArea.minX..<gameArea.maxX)
        let randomXEnd = CGFloat.random(in: gameArea.minX..<gameArea.maxX)
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        let EnemyDecider = Int.random(in: 1..<8)
        var enemy : SKSpriteNode!
        if EnemyDecider == 1{
            enemy = SKSpriteNode(imageNamed: "enemySmall")
            enemy.name = "OPPBOY"
            enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
            enemy.physicsBody!.affectedByGravity = false
        }
        if EnemyDecider == 2{
            enemy = SKSpriteNode(imageNamed: "AsteroidSmall")
            enemy.name = "ROID"
            enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
            enemy.physicsBody!.affectedByGravity = false
        }
        if EnemyDecider == 3{
            let Lucky = Int.random(in: 1..<8)
            if Lucky == 2{
                enemy = SKSpriteNode(imageNamed: "BoostCoin1")
                enemy.name = "BOOST"
                enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
                enemy.physicsBody!.affectedByGravity = false
            }
            else{
                enemy = SKSpriteNode(imageNamed: "AsteroidSmall")
                enemy.name = "ROID"
                enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
                enemy.physicsBody!.affectedByGravity = false
            }
        }
        if EnemyDecider == 4{
            let Lucky = Int.random(in: 1..<3)
            if Lucky == 2{
                enemy = SKSpriteNode(imageNamed: "GA1")
                enemy.name = "GOLDROID"
                enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
                enemy.physicsBody!.affectedByGravity = false
            }
            else{
                enemy = SKSpriteNode(imageNamed: "GA1")
                enemy.name = "GOLDROID"
                enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
                enemy.physicsBody!.affectedByGravity = false
            }
        }
        if EnemyDecider == 5{
            let Lucky = Int.random(in: 1..<8)
            if Lucky == 2{
                enemy = SKSpriteNode(imageNamed: "PurpleXP1")
                enemy.name = "DoubleXP"
                enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
                enemy.physicsBody!.affectedByGravity = false
            }
            else{
                enemy = SKSpriteNode(imageNamed: "Purple1")
                enemy.name = "PURP"
                enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
                enemy.physicsBody!.affectedByGravity = false
            }
        }
        if EnemyDecider == 6{
            enemy = SKSpriteNode(imageNamed: "Green1")
            enemy.name = "Green"
            enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
            enemy.physicsBody!.affectedByGravity = false
        }
        if EnemyDecider == 7{
            enemy = SKSpriteNode(imageNamed: "Blue1")
            enemy.name = "Blue"
            enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
            enemy.physicsBody!.affectedByGravity = false
        }
       
        enemy.position = startPoint
        enemy.zPosition = 1
        self.addChild(enemy)

        
        let moveEnemy = SKAction.move(to: endPoint, duration: 2)
        let anim =  SKAction.animate(with: AsteroidTextureArray, timePerFrame: 0.009)
        let anim4eva = SKAction.repeatForever(anim)
        let anim1 =  SKAction.animate(with: GoldAsteroidTextureArray, timePerFrame: 0.009)
        let anim4eva1 = SKAction.repeatForever(anim1)
        let anim2 =  SKAction.animate(with: BoostCoinTextureArray, timePerFrame: 0.009)
        let anim4eva2 = SKAction.repeatForever(anim2)
        let anim3 = SKAction.animate(with: PurpleDiamondTextureArray, timePerFrame: 0.009)
        let anim4eva3 = SKAction.repeatForever(anim3)
        let anim4 =  SKAction.animate(with: EnemyTextureArray, timePerFrame: 0.1)
        let anim4eva4 = SKAction.repeatForever(anim4)
        let anim5 = SKAction.animate(with: BlueDiamondTextureArray, timePerFrame: 0.009)
        let anim4eva5 = SKAction.repeatForever(anim5)
        let anim6 = SKAction.animate(with: GreenDiamondTextureArray, timePerFrame: 0.009)
        let anim4eva6 = SKAction.repeatForever(anim6)
        let deleteEnemy = SKAction.removeFromParent()
        let moveAndRemove = SKAction.sequence([moveEnemy, deleteEnemy])
        let moveAndRemoveandLive = SKAction.sequence([moveEnemy, deleteEnemy])
        let grop = SKAction.group([anim4eva, moveAndRemove])
        let grop1 = SKAction.group([anim4eva1, moveAndRemove])
        let grop2 = SKAction.group([anim4eva2, moveAndRemove])
        let grop4 = SKAction.group([anim4eva4, moveAndRemoveandLive])
        let grop5 = SKAction.group([anim4eva3, moveAndRemove])
        let grop6 = SKAction.group([anim4eva5, moveAndRemove])
        let grop7 = SKAction.group([anim4eva6, moveAndRemove])

            // We do this as only the enemy ships should take lives off the player
            if enemy.name == "GOLDROID"{
                enemy.run(grop1)
            }
            if enemy.name == "BOOST"{
                enemy.run(grop2)
            }
            if enemy.name == "DoubleXP"{
                enemy.run(moveAndRemove)
            }
            if enemy.name == "ROID"{
                enemy.run(grop)
            }
            if enemy.name == "OPPBOY"{
                enemy.run(grop4)
            }
        if enemy.name == "PURP"{
            enemy.run(grop5)
        }
        if enemy.name == "Blue"{
            enemy.run(grop6)
        }
        if enemy.name == "Green"{
            enemy.run(grop7)
        }
        
        let diffX = endPoint.x - startPoint.x
        let diffY = endPoint.y - startPoint.y
        let amount2Rotate = atan2(diffY, diffX)
        enemy.zRotation = amount2Rotate
        

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
            
            if homelabel.contains(pointTouched){
                let destination = RocketShipHomeScreen(size: self.size)
                destination.scaleMode = self.scaleMode
                let transition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(destination, transition: transition)
            }
        }
        
    }
}
