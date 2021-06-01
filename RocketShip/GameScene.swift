//
//  GameScene.swift
//  RocketShip
//
//  Created by Josh Manik on 08/03/2021.
//

import SpriteKit
import GameplayKit

var userScore = 0

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var levelNumber = 0
    
    // These are variables that ensure the flames are shown within their order so the animation  is smoother
    
    var flipper = 0
    var RightFlipper = 0
    var StraightFlipper = 0
    
    let ScoreLabel = SKLabelNode(fontNamed: "ADAM.CGPRO")
    
    var BackgroundAnimation: Timer!
    var AsteroidSpinner: Timer!
    let background = SKSpriteNode(imageNamed: "glitter-universe-1-1")
    var enemy : SKSpriteNode!
    var ticker = 0
    var spinner = 0
    
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
    
    var BackgroundTextureAtlas = SKTextureAtlas()
    var BackgroundTextureArray: [SKTexture] = []
    
    var BoostedBackgroundTextureAtlas = SKTextureAtlas()
    var BoostedBackgroundTextureArray: [SKTexture] = []
    
    var DoublePointsBackgroundTextureAtlas = SKTextureAtlas()
    var DoublePointsBackgroundTextureArray: [SKTexture] = []
    
    var BoostedDoublePointsBackgroundTextureAtlas = SKTextureAtlas()
    var BoostedDoublePointsBackgroundTextureArray: [SKTexture] = []
    
    var lives = 3
    let LivesLabel = SKLabelNode(fontNamed: "ADAM.CGPRO")
    
    // Adding the player to the scene
    
    let player = SKSpriteNode(imageNamed: "E1")
    
    var DoubleXPTimer : Timer!
    
    var BoostedTimer : Timer!
    
    var counter = 0
    var count: Int = 0
    
    enum gameState{
        
        case PreGame
        case DuringGame
        case GameFinished
        
    }
    
    var currentGameState = gameState.DuringGame

    struct PhysicsCatergories {
        
        static let None: UInt32 = 0
        
        static let Player: UInt32 = 1
        
        static let Bullet: UInt32 = 2
        
        static let Enemy: UInt32 = 4
        
        static let Asteroid: UInt32 = 8
        
        static let DoublePoints: UInt32 = 16
        
        static let GoldCoin: UInt32 = 32
        
        static let AsteroidFragment: UInt32 = 64
        
        static let GoldAsteroid: UInt32 = 128
        
        static let XPCoin: UInt32 = 256
        
        static let PurpleDiamond: UInt32 = 512
        
        static let GreenDiamond: UInt32 = 1024
        
        static let BlueDiamond: UInt32 = 2048
    }
    
    enum PlayerRocketStatus {
        case TurningLeft
        case TurningRight
        case Straight
    }
    
    enum RocketMode {
        case Boosted
        case Normal
        case DoubleXP
        case BoostedDoubleXP
    }
    
    var CurrentPlayerRocketStatus = PlayerRocketStatus.Straight
    var CurrentRocketMode = RocketMode.Normal
    
    
    
    
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
    
    override func didMove(to view: SKView) {
        
        userScore = 0
        
        self.physicsWorld.contactDelegate = self
        
        // Adding the background to the scene
        
        background.size = CGSize (width: frame.maxX, height: frame.maxY)
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
                
        player.setScale(1)
        
        // We times the height by 0.2 as we want the ship to start 20% up from the bottom
        
        player.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.2)

        player.zPosition = 3

        self.addChild(player)
        player.physicsBody = SKPhysicsBody(texture: player.texture!,
                                           size: player.texture!.size())
        player.physicsBody!.affectedByGravity = false
        player.name = "Player"
        player.physicsBody!.categoryBitMask = PhysicsCatergories.Player
        player.physicsBody!.collisionBitMask = PhysicsCatergories.None
        player.physicsBody!.contactTestBitMask = PhysicsCatergories.Enemy
        
        
        ScoreLabel.text = "Score : 0"
        ScoreLabel.fontSize = 70
        ScoreLabel.fontColor = SKColor.white
        ScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        ScoreLabel.position = CGPoint(x:self.size.width * 0.20, y: self.size.height * 0.9)
        ScoreLabel.zPosition = 100
        
        LivesLabel.text = "Lives : \(lives)"
        LivesLabel.fontSize = 70
        LivesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        LivesLabel.position = CGPoint(x: self.size.width * 0.8, y: self.size.height * 0.9)
        LivesLabel.zPosition = 100
        self.addChild(LivesLabel)
        self.addChild(ScoreLabel)
        
        AsteroidTextureAtlas = SKTextureAtlas(named: "AsteroidSpin.atlas")
        PlayerShipTextureAtlas = SKTextureAtlas(named: "Boost.atlas")
        PlayerShipBoostedTextureAtlas = SKTextureAtlas(named: "Boost.atlas")
        BackgroundTextureAtlas = SKTextureAtlas(named: "BackgroundImages.atlas")
        BoostedBackgroundTextureAtlas = SKTextureAtlas(named: "BoostedBackground.atlas")
        DoublePointsBackgroundTextureAtlas = SKTextureAtlas(named: "DoublePointsBackground.atlas")
        BoostedDoublePointsBackgroundTextureAtlas = SKTextureAtlas(named: "BoostedDoublePointsBackground.atlas")
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
        for p in 1...BoostedBackgroundTextureAtlas.textureNames.count{
            let texture = "red-universe-1-\(p).png"
            BoostedBackgroundTextureArray.append(SKTexture(imageNamed: texture))
        }
        for p in 1...DoublePointsBackgroundTextureAtlas.textureNames.count{
            let texture = "green-universe-1-\(p).png"
            DoublePointsBackgroundTextureArray.append(SKTexture(imageNamed: texture))
        }
        for p in 1...BoostedDoublePointsBackgroundTextureAtlas.textureNames.count{
            let texture = "gold-universe-1-\(p).png"
            BoostedDoublePointsBackgroundTextureArray.append(SKTexture(imageNamed: texture))
        }
        
        let anim =  SKAction.animate(with: BackgroundTextureArray, timePerFrame: 0.02)
        let anim4eva = SKAction.repeatForever(anim)
        background.run(anim4eva, withKey: "StanBack")
        
        let an1m = SKAction.animate(with: PlayerShipTextureArray, timePerFrame: 0.08)
        let an1m4eva = SKAction.repeatForever(an1m)
        player.run(an1m4eva, withKey:"Standard")


        startNewLevel()
        
    }
    

    
    func loselives(){
        lives -= 1
        LivesLabel.text = "Lives : \(lives)"
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let sequence = SKAction.sequence([scaleUp, scaleDown])
        LivesLabel.run(sequence)
        
        if lives == 0{
            gameOver()
        }

    }
    
    func addScore(number: Int){
        userScore += number
        ScoreLabel.text = "Score: \(userScore)"
        
    }
    
    func AddBonus(){
        userScore += 2
        ScoreLabel.text = "Score: \(userScore)"
    }
    
    func gameOver(){
        
        currentGameState = gameState.GameFinished
        
        self.removeAllActions()
        
        self.enumerateChildNodes(withName: "BullitBang"){
            bullet, stop in
            bullet.removeAllActions()
        }
        
        self.enumerateChildNodes(withName: "OPPBOY"){
            enemy, stop in
            enemy.removeAllActions()
        }
        
        let ChangeSceneAction = SKAction.run(changeScene)
        let waitForChange = SKAction.wait(forDuration: 1)
        let sequence = SKAction.sequence([waitForChange, ChangeSceneAction])
        self.run(sequence)
    }
    
    func changeScene(){
        let destination = GameOverScene(size:self.size)
        destination.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(destination, transition: myTransition)
    }
    

    
    
    // Fire Bullet function
    
    func ShootBullet() {
        let bullet = SKSpriteNode(imageNamed: "MissileFinished")
        bullet.name = "BullitBang"
        bullet.setScale(1)
        bullet.position = player.position
        bullet.zPosition = 1
        bullet.physicsBody = SKPhysicsBody(texture: player.texture!,
                                           size: player.texture!.size())
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = PhysicsCatergories.Bullet
        bullet.physicsBody!.collisionBitMask = PhysicsCatergories.None
        bullet.physicsBody!.contactTestBitMask = PhysicsCatergories.Enemy
        self.addChild(bullet)
        
        let fireBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let removeBullet = SKAction.removeFromParent()
        let ActionsToPerform = SKAction.sequence([fireBullet, removeBullet])
        bullet.run(ActionsToPerform)
    }
    
    // Function for creating enemies
    
    
    func SpawnEnemy(){
        
        let randomXStart = CGFloat.random(in: gameArea.minX..<gameArea.maxX)
        let randomXEnd = CGFloat.random(in: gameArea.minX..<gameArea.maxX)
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        let EnemyDecider = Int.random(in: 1..<6)
        var enemy : SKSpriteNode!
        if EnemyDecider == 1{
            enemy = SKSpriteNode(imageNamed: "enemySmall")
            enemy.name = "OPPBOY"
            enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
            enemy.physicsBody!.affectedByGravity = false
            enemy.physicsBody!.categoryBitMask = PhysicsCatergories.Enemy
            enemy.physicsBody!.collisionBitMask = PhysicsCatergories.Enemy | PhysicsCatergories.Bullet
            enemy.physicsBody!.contactTestBitMask = PhysicsCatergories.Player | PhysicsCatergories.Bullet
        }
        if EnemyDecider == 2{
            enemy = SKSpriteNode(imageNamed: "AsteroidSmall")
            enemy.name = "ROID"
            enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
            enemy.physicsBody!.affectedByGravity = false
            enemy.physicsBody!.categoryBitMask = PhysicsCatergories.Asteroid
            enemy.physicsBody!.collisionBitMask = PhysicsCatergories.Enemy | PhysicsCatergories.Bullet
            enemy.physicsBody!.contactTestBitMask = PhysicsCatergories.Player | PhysicsCatergories.Bullet
        }
        if EnemyDecider == 3{
            let Lucky = Int.random(in: 1..<8)
            if Lucky == 2{
                enemy = SKSpriteNode(imageNamed: "BoostCoin1")
                enemy.name = "BOOST"
                enemy.physicsBody = SKPhysicsBody(circleOfRadius: enemy.size.width)
                enemy.physicsBody!.affectedByGravity = false
                enemy.physicsBody!.categoryBitMask = PhysicsCatergories.GoldCoin
                enemy.physicsBody!.collisionBitMask = PhysicsCatergories.Enemy | PhysicsCatergories.Bullet
                enemy.physicsBody!.contactTestBitMask = PhysicsCatergories.Player | PhysicsCatergories.Bullet
            }
            else{
                enemy = SKSpriteNode(imageNamed: "AsteroidSmall")
                enemy.name = "ROID"
                enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
                enemy.physicsBody!.affectedByGravity = false
                enemy.physicsBody!.categoryBitMask = PhysicsCatergories.Asteroid
                enemy.physicsBody!.collisionBitMask = PhysicsCatergories.Enemy | PhysicsCatergories.Bullet
                enemy.physicsBody!.contactTestBitMask = PhysicsCatergories.Player | PhysicsCatergories.Bullet
            }
        }
        if EnemyDecider == 4{
            let Lucky = Int.random(in: 1..<3)
            if Lucky == 2{
                enemy = SKSpriteNode(imageNamed: "GA1")
                enemy.name = "GOLDROID"
                enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
                enemy.physicsBody!.affectedByGravity = false
                enemy.physicsBody!.categoryBitMask = PhysicsCatergories.GoldAsteroid
                enemy.physicsBody!.collisionBitMask = PhysicsCatergories.Enemy | PhysicsCatergories.Bullet
                enemy.physicsBody!.contactTestBitMask = PhysicsCatergories.Player | PhysicsCatergories.Bullet
            }
            else{
                enemy = SKSpriteNode(imageNamed: "GA1")
                enemy.name = "GOLDROID"
                enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
                enemy.physicsBody!.affectedByGravity = false
                enemy.physicsBody!.categoryBitMask = PhysicsCatergories.GoldAsteroid
                enemy.physicsBody!.collisionBitMask = PhysicsCatergories.Enemy | PhysicsCatergories.Bullet
                enemy.physicsBody!.contactTestBitMask = PhysicsCatergories.Player | PhysicsCatergories.Bullet
            }
        }
        if EnemyDecider == 5{
            let Lucky = Int.random(in: 1..<8)
            if Lucky == 2{
                enemy = SKSpriteNode(imageNamed: "PurpleXP1")
                enemy.name = "DoubleXP"
                enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
                enemy.physicsBody!.affectedByGravity = false
                enemy.physicsBody!.categoryBitMask = PhysicsCatergories.XPCoin
                enemy.physicsBody!.collisionBitMask = PhysicsCatergories.Enemy | PhysicsCatergories.Bullet
                enemy.physicsBody!.contactTestBitMask = PhysicsCatergories.Player | PhysicsCatergories.Bullet
            }
            else{
                enemy = SKSpriteNode(imageNamed: "AsteroidSmall")
                enemy.name = "ROID"
                enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
                enemy.physicsBody!.affectedByGravity = false
                enemy.physicsBody!.categoryBitMask = PhysicsCatergories.Asteroid
                enemy.physicsBody!.collisionBitMask = PhysicsCatergories.Enemy | PhysicsCatergories.Bullet
                enemy.physicsBody!.contactTestBitMask = PhysicsCatergories.Player | PhysicsCatergories.Bullet
            }
        }
       
        enemy.position = startPoint
        enemy.zPosition = 2
        self.addChild(enemy)

        
        let moveEnemy = SKAction.move(to: endPoint, duration: 2)
        let anim =  SKAction.animate(with: AsteroidTextureArray, timePerFrame: 0.009)
        let anim4eva = SKAction.repeatForever(anim)
        let anim1 =  SKAction.animate(with: GoldAsteroidTextureArray, timePerFrame: 0.009)
        let anim4eva1 = SKAction.repeatForever(anim1)
        let anim2 =  SKAction.animate(with: BoostCoinTextureArray, timePerFrame: 0.009)
        let anim4eva2 = SKAction.repeatForever(anim2)

        let anim4 =  SKAction.animate(with: EnemyTextureArray, timePerFrame: 0.1)
        let anim4eva4 = SKAction.repeatForever(anim4)
        let deleteEnemy = SKAction.removeFromParent()
        let wellDoneSoldier = SKAction.run(loselives)
        let moveAndRemove = SKAction.sequence([moveEnemy, deleteEnemy])
        let moveAndRemoveandLive = SKAction.sequence([moveEnemy, deleteEnemy, wellDoneSoldier])
        let grop = SKAction.group([anim4eva, moveAndRemove])
        let grop1 = SKAction.group([anim4eva1, moveAndRemove])
        let grop2 = SKAction.group([anim4eva2, moveAndRemove])
        let grop4 = SKAction.group([anim4eva4, moveAndRemoveandLive])
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy, wellDoneSoldier])
        if currentGameState == gameState.DuringGame{

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
        }
        let diffX = endPoint.x - startPoint.x
        let diffY = endPoint.y - startPoint.y
        let amount2Rotate = atan2(diffY, diffX)
        enemy.zRotation = amount2Rotate
        

    }
    
    func StopSpinner(){
        AsteroidSpinner.invalidate()
    }
    
    @objc func BoostedTime(){
        print(count)
        if BoostedTimer != nil{
        if count > 0{
            count -= 1
        };if count == 0{
            print("Finish")
            player.removeAction(forKey: "BOOST")
            let an1m = SKAction.animate(with: PlayerShipTextureArray, timePerFrame: 0.05)
            let an1m4eva = SKAction.repeatForever(an1m)
            player.run(an1m4eva, withKey: "Standard")
            if CurrentRocketMode == RocketMode.BoostedDoubleXP{CurrentRocketMode = RocketMode.DoubleXP}
            if CurrentRocketMode == RocketMode.Boosted{CurrentRocketMode = RocketMode.Normal}
        }
    }
    }
    
    
    @objc func DoubleTime(){
        if DoubleXPTimer != nil{
        if count > 0{
            count -= 1
        };if count == 0{
            print("Finish")
            player.removeAction(forKey: "BOOST")
            let an1m = SKAction.animate(with: PlayerShipTextureArray, timePerFrame: 0.05)
            let an1m4eva = SKAction.repeatForever(an1m)
            player.run(an1m4eva, withKey: "Standard")
            if CurrentRocketMode == RocketMode.BoostedDoubleXP{CurrentRocketMode = RocketMode.Boosted}
            if CurrentRocketMode == RocketMode.DoubleXP{CurrentRocketMode = RocketMode.Normal}
            DoubleXPTimer.invalidate()
            DoubleXPTimer = nil
        }
    }
    }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        if currentGameState == gameState.DuringGame{
        ShootBullet()
        }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            body1 = contact.bodyA
            body2 = contact.bodyB
        }else{
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        print(body1.node?.name)
        print(body2.node?.name)
        
        // If the player hits the enemy
        
        if body1.categoryBitMask == PhysicsCatergories.Player && body2.categoryBitMask == PhysicsCatergories.Enemy{
            
            if CurrentRocketMode == RocketMode.BoostedDoubleXP{
                if body2.node != nil{Explode(explodeposition: body2.node!.position)}
                body2.node?.removeFromParent()
                addScore(number: 2)
            }
            if CurrentRocketMode == RocketMode.DoubleXP{
                if body1.node != nil{Explode(explodeposition: body1.node!.position)}
                if body2.node != nil{Explode(explodeposition: body2.node!.position)}

                body1.node?.removeFromParent()
                body2.node?.removeFromParent()
                
                gameOver()
            }
            if CurrentRocketMode == RocketMode.Boosted{
                if body2.node != nil{Explode(explodeposition: body2.node!.position)}
                body2.node?.removeFromParent()
                addScore(number: 1)
            }
            if CurrentRocketMode == RocketMode.Normal{
                if body1.node != nil{Explode(explodeposition: body1.node!.position)}
                if body2.node != nil{Explode(explodeposition: body2.node!.position)}

                body1.node?.removeFromParent()
                body2.node?.removeFromParent()
                
                gameOver()
            }
        }
        
        // If the player runs into the gold coin
        
        if body1.categoryBitMask == PhysicsCatergories.Player && body2.categoryBitMask == PhysicsCatergories.GoldCoin{
            
            // Since we hit the gold coin we want to give a bonus life and invunerable travel travel
            // My thought process is to call a 30 second timer in which we set the rocketmode to boosted.
            if CurrentRocketMode == RocketMode.DoubleXP{
                CurrentRocketMode = RocketMode.BoostedDoubleXP
                let boost = SKAction.animate(with: PlayerShipBoostedTextureArray, timePerFrame: 0.1)
                let boost4eva = SKAction.repeatForever(boost)
                player.removeAction(forKey: "Standard")
                player.run(boost4eva, withKey: "BOOST")
                
                let boostback = SKAction.animate(with: BoostedDoublePointsBackgroundTextureArray, timePerFrame: 0.02)
                let boostback4eva = SKAction.repeatForever(boostback)
                background.removeAction(forKey: "DoubleBack")
                background.run(boostback4eva, withKey: "DoubleBoostBack")
                count = 10
            }
            if CurrentRocketMode == RocketMode.Normal{
                CurrentRocketMode = RocketMode.Boosted
                let boost = SKAction.animate(with: PlayerShipBoostedTextureArray, timePerFrame: 0.1)
                let boost4eva = SKAction.repeatForever(boost)
                player.removeAction(forKey: "Standard")
                player.run(boost4eva, withKey: "BOOST")
                
                let boostback = SKAction.animate(with: BoostedBackgroundTextureArray, timePerFrame: 0.02)
                let boostback4eva = SKAction.repeatForever(boostback)
                background.removeAction(forKey: "StanBack")
                background.run(boostback4eva, withKey: "BoostBack")
                count = 10
            }
            body2.node?.removeFromParent()
            
        }
        
        // If the player runs into 2x coin
        
        if body1.categoryBitMask == PhysicsCatergories.Player && body2.categoryBitMask == PhysicsCatergories.XPCoin{
            
            // Since we hit the 2X coin we want to give doublepoints
            // My thought process is to call a 30 second timer in which we set the rocketmode to boosted.
            if CurrentRocketMode == RocketMode.Boosted{
                CurrentRocketMode = RocketMode.BoostedDoubleXP
                let boost = SKAction.animate(with: PlayerShipBoostedTextureArray, timePerFrame: 0.1)
                let boost4eva = SKAction.repeatForever(boost)
                player.removeAction(forKey: "Standard")
                player.run(boost4eva, withKey: "BOOST")
                
                let boostback = SKAction.animate(with: BoostedDoublePointsBackgroundTextureArray, timePerFrame: 0.02)
                let boostback4eva = SKAction.repeatForever(boostback)
                background.removeAction(forKey: "DoubleBack")
                background.run(boostback4eva, withKey: "DoubleBoostBack")
                count = 10
            }
            if CurrentRocketMode == RocketMode.Normal{
                CurrentRocketMode = RocketMode.DoubleXP
                let boost = SKAction.animate(with: PlayerShipBoostedTextureArray, timePerFrame: 0.1)
                let boost4eva = SKAction.repeatForever(boost)
                player.removeAction(forKey: "Standard")
                player.run(boost4eva, withKey: "BOOST")
                
                let boostback = SKAction.animate(with: DoublePointsBackgroundTextureArray, timePerFrame: 0.02)
                let boostback4eva = SKAction.repeatForever(boostback)
                background.removeAction(forKey: "StanBack")
                background.run(boostback4eva, withKey: "BoostBack")
                count = 10
            }
            body2.node?.removeFromParent()
        }
        
        // If the bullet hits the gold coin
        
        if body1.categoryBitMask == PhysicsCatergories.Bullet && body2.categoryBitMask == PhysicsCatergories.GoldCoin{
            if body2.node != nil{
                
                if body2.node!.position.y > self.size.height{
                    return
                }else{
                    Explodecoin(explodeposition: body2.node!.position)
                    body2.node?.removeFromParent()
                }
        }
        }
        
        // Bullet hits 2X Coin
        
        if body1.categoryBitMask == PhysicsCatergories.Bullet && body2.categoryBitMask == PhysicsCatergories.XPCoin{
            if body2.node != nil{
                
                if body2.node!.position.y > self.size.height{
                    return
                }else{
                    ExplodePurpleDiamond(explodeposition: body2.node!.position)
                    body2.node?.removeFromParent()
                }
        }
        }
        
        // If the bullet hits the enemy
        if body1.categoryBitMask == PhysicsCatergories.Bullet && body2.categoryBitMask == PhysicsCatergories.Enemy{
            
            if body2.node != nil{
                // Check wether the enemy is on screen when the bullet makes contact
                if body2.node!.position.y > self.size.height{
                    return
                }else{
                    // we know this is on the screen so we want to show an explosion
                    if CurrentRocketMode == RocketMode.BoostedDoubleXP{
                        Explode(explodeposition: body2.node!.position)
                        addScore(number: 2)
                    }
                    if CurrentRocketMode == RocketMode.DoubleXP{
                        Explode(explodeposition: body2.node!.position)
                        addScore(number: 2)
                    }
                    if CurrentRocketMode == RocketMode.Boosted{
                        Explode(explodeposition: body2.node!.position)
                        addScore(number: 1)
                    }
                    if CurrentRocketMode == RocketMode.Normal{
                        Explode(explodeposition: body2.node!.position)
                        addScore(number: 1)
                    }
                }
                body1.node?.removeFromParent()
                body2.node?.removeFromParent()
            }
        }
        
        // If the bullet hits the asteroid
        if body1.categoryBitMask == PhysicsCatergories.Bullet && body2.categoryBitMask == PhysicsCatergories.Asteroid{
            if body2.node != nil{
                // Check wether the enemy is on screen when the bullet makes contact
                if body2.node!.position.y > self.size.height{
                    return
                }else{
                    let startofFragmentation = body2.node!.position
                    Explode(explodeposition: body2.node!.position)
                    
                    FragmentAsteroid(FragPosition: startofFragmentation)
                    body1.node?.removeFromParent()
                    body2.node?.removeFromParent()
                }
            }
        }
        
        // If the bullet hits the GOLD asteroid
        if body1.categoryBitMask == PhysicsCatergories.Bullet && body2.categoryBitMask == PhysicsCatergories.GoldAsteroid{
            if body2.node != nil{
                // Check wether the enemy is on screen when the bullet makes contact
                if body2.node!.position.y > self.size.height{
                    return
                }else{
                    let startofFragmentation = body2.node!.position
                    Explode(explodeposition: body2.node!.position)
                    
                    FragmentGoldAsteroid(FragPosition: startofFragmentation)
                    body1.node?.removeFromParent()
                    body2.node?.removeFromParent()
                }
            }
        }
        
        // If the bullet hits the asteroid fragment
        if body1.categoryBitMask == PhysicsCatergories.Bullet && body2.categoryBitMask == PhysicsCatergories.AsteroidFragment{
            if body2.node != nil{
                // Check wether the enemy is on screen when the bullet makes contact
                if body2.node!.position.y > self.size.height{
                    return
                }else{
                    Explode(explodeposition: body2.node!.position)
                    body1.node?.removeFromParent()
                    body2.node?.removeFromParent()
                }
            }
        }
        
        // If the player hits the asteroid
        if body1.categoryBitMask == PhysicsCatergories.Player && body2.categoryBitMask == PhysicsCatergories.Asteroid{
            
            if CurrentRocketMode == RocketMode.BoostedDoubleXP{
                if body2.node != nil{Explode(explodeposition: body2.node!.position)}
                body2.node?.removeFromParent()
                addScore(number: 2)
            }
            if CurrentRocketMode == RocketMode.DoubleXP{
                if body1.node != nil{Explode(explodeposition: body1.node!.position)}
                if body2.node != nil{Explode(explodeposition: body2.node!.position)}

                body1.node?.removeFromParent()
                body2.node?.removeFromParent()
                gameOver()
            }
            if CurrentRocketMode == RocketMode.Boosted{
                if body2.node != nil{Explode(explodeposition: body2.node!.position)}
                body2.node?.removeFromParent()
                addScore(number: 1)
            }
            if CurrentRocketMode == RocketMode.Normal{
                if body1.node != nil{Explode(explodeposition: body1.node!.position)}
                if body2.node != nil{Explode(explodeposition: body2.node!.position)}

                body1.node?.removeFromParent()
                body2.node?.removeFromParent()
                gameOver()
            }
        }
        
        // If the player hits the GOLD asteroid
        if body1.categoryBitMask == PhysicsCatergories.Player && body2.categoryBitMask == PhysicsCatergories.GoldAsteroid{
            
            if CurrentRocketMode == RocketMode.BoostedDoubleXP{
                if body2.node != nil{ExplodePurpleDiamond(explodeposition: body2.node!.position)}
                body2.node?.removeFromParent()
                addScore(number: 10)
            }
            if CurrentRocketMode == RocketMode.DoubleXP{
                if body1.node != nil{Explode(explodeposition: body1.node!.position)}
                if body2.node != nil{ExplodePurpleDiamond(explodeposition: body2.node!.position)}

                body1.node?.removeFromParent()
                body2.node?.removeFromParent()
                gameOver()
            }
            if CurrentRocketMode == RocketMode.Boosted{
                if body2.node != nil{Explode(explodeposition: body2.node!.position)}
                body2.node?.removeFromParent()
                addScore(number: 5)
            }
            if CurrentRocketMode == RocketMode.Normal{
                if body1.node != nil{Explode(explodeposition: body1.node!.position)}
                if body2.node != nil{ExplodePurpleDiamond(explodeposition: body2.node!.position)}

                body1.node?.removeFromParent()
                body2.node?.removeFromParent()
                gameOver()
            }
        }
        
        // If the player hits an asteroid fragment
        if body1.categoryBitMask == PhysicsCatergories.Player && body2.categoryBitMask == PhysicsCatergories.AsteroidFragment{
            
            if CurrentRocketMode == RocketMode.BoostedDoubleXP{
                if body2.node != nil{Explode(explodeposition: body2.node!.position)}
                body2.node?.removeFromParent()
                addScore(number: 2)
            }
            if CurrentRocketMode == RocketMode.DoubleXP{
                if body1.node != nil{Explode(explodeposition: body1.node!.position)}
                if body2.node != nil{Explode(explodeposition: body2.node!.position)}

                body1.node?.removeFromParent()
                body2.node?.removeFromParent()
                gameOver()
            }
            if CurrentRocketMode == RocketMode.Boosted{
                if body2.node != nil{Explode(explodeposition: body2.node!.position)}
                body2.node?.removeFromParent()
                addScore(number: 1)
            }
            if CurrentRocketMode == RocketMode.Normal{
                if body1.node != nil{Explode(explodeposition: body1.node!.position)}
                if body2.node != nil{ExplodePurpleDiamond(explodeposition: body2.node!.position)}

                body1.node?.removeFromParent()
                body2.node?.removeFromParent()
                gameOver()
            }
        }
        
        // If the player hits a Purple diamond
        if body1.categoryBitMask == PhysicsCatergories.Player && body2.categoryBitMask == PhysicsCatergories.PurpleDiamond{
            
            if CurrentRocketMode == RocketMode.BoostedDoubleXP{
                body2.node?.removeFromParent()
                addScore(number: 20)
            }
            if CurrentRocketMode == RocketMode.DoubleXP{
                body2.node?.removeFromParent()
                addScore(number: 20)
            }
            if CurrentRocketMode == RocketMode.Boosted{
                body2.node?.removeFromParent()
                addScore(number: 10)
            }
            if CurrentRocketMode == RocketMode.Normal{
                body2.node?.removeFromParent()
                addScore(number: 10)
            }
            }
        
        
        // If a bullet hits a purple diamond
        if body1.categoryBitMask == PhysicsCatergories.Bullet && body2.categoryBitMask == PhysicsCatergories.PurpleDiamond{
            if body2.node != nil{ExplodePurpleDiamond(explodeposition: body2.node!.position)}
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            }
    }
    
    @objc func BoostedCountdown(){
        if counter > 0{
            counter -= 1
            CurrentRocketMode = RocketMode.Boosted
        }
        else{
            BoostedTimer.invalidate()
            BoostedTimer = nil
            CurrentRocketMode = RocketMode.Normal
        }
    }
    
    func Explode(explodeposition: CGPoint){
        let explosion = SKSpriteNode(imageNamed: "Explosionred")
        explosion.position = explodeposition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
        let fade = SKAction.fadeOut(withDuration: 0.1)
        let remove = SKAction.removeFromParent()
        let explosionSequence = SKAction.sequence([scaleIn, fade, remove])
        explosion.run(explosionSequence)
    }
    func Explodecoin(explodeposition: CGPoint){
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.position = explodeposition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
        let fade = SKAction.fadeOut(withDuration: 0.1)
        let remove = SKAction.removeFromParent()
        let explosionSequence = SKAction.sequence([scaleIn, fade, remove])
        explosion.run(explosionSequence)
    }
    func Exploderoid(explodeposition: CGPoint){
        let explosion = SKSpriteNode(imageNamed: "Explosion2")
        explosion.position = explodeposition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
        let fade = SKAction.fadeOut(withDuration: 0.1)
        let remove = SKAction.removeFromParent()
        let explosionSequence = SKAction.sequence([scaleIn, fade, remove])
        explosion.run(explosionSequence)
    }
    func ExplodePurpleDiamond(explodeposition: CGPoint){
        let explosion = SKSpriteNode(imageNamed: "explosion1purple")
        explosion.position = explodeposition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
        let fade = SKAction.fadeOut(withDuration: 0.1)
        let remove = SKAction.removeFromParent()
        let explosionSequence = SKAction.sequence([scaleIn, fade, remove])
        explosion.run(explosionSequence)
    }

    func FragmentAsteroid(FragPosition: CGPoint){
        let startPoint = FragPosition
        let randomXEnd = CGFloat.random(in: gameArea.minX..<gameArea.maxX)
        let randomXEnd2 = CGFloat.random(in: gameArea.minX..<gameArea.maxX)
        let randomXEnd3 = CGFloat.random(in: gameArea.minX..<gameArea.maxX)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        let endPoint2 = CGPoint(x: randomXEnd2, y: -self.size.height * 0.2)
        let endPoint3 = CGPoint(x: randomXEnd3, y: -self.size.height * 0.2)
        let enemy1 : SKSpriteNode
        enemy1 = SKSpriteNode(imageNamed: "Asteroidfrag")
        enemy1.name = "ROID"
        enemy1.physicsBody = SKPhysicsBody(rectangleOf: enemy1.size)
        enemy1.physicsBody!.affectedByGravity = false
        enemy1.physicsBody!.categoryBitMask = PhysicsCatergories.AsteroidFragment
        enemy1.physicsBody!.collisionBitMask = PhysicsCatergories.Enemy | PhysicsCatergories.Bullet
        enemy1.physicsBody!.contactTestBitMask = PhysicsCatergories.Player | PhysicsCatergories.Bullet
        enemy1.position = startPoint
        enemy1.zPosition = 2
        self.addChild(enemy1)
        let enemy2 : SKSpriteNode
        enemy2 = SKSpriteNode(imageNamed: "AsteroidFrag2")
        enemy2.name = "ROID"
        enemy2.physicsBody = SKPhysicsBody(rectangleOf: enemy2.size)
        enemy2.physicsBody!.affectedByGravity = false
        enemy2.physicsBody!.categoryBitMask = PhysicsCatergories.AsteroidFragment
        enemy2.physicsBody!.collisionBitMask = PhysicsCatergories.Enemy | PhysicsCatergories.Bullet
        enemy2.physicsBody!.contactTestBitMask = PhysicsCatergories.Player | PhysicsCatergories.Bullet
        enemy2.position = startPoint
        enemy2.zPosition = 2
        self.addChild(enemy2)
        let enemy3 : SKSpriteNode
        enemy3 = SKSpriteNode(imageNamed: "asteroidfrag3")
        enemy3.name = "ROID"
        enemy3.physicsBody = SKPhysicsBody(rectangleOf: enemy3.size)
        enemy3.physicsBody!.affectedByGravity = false
        enemy3.physicsBody!.categoryBitMask = PhysicsCatergories.AsteroidFragment
        enemy3.physicsBody!.collisionBitMask = PhysicsCatergories.Enemy | PhysicsCatergories.Bullet
        enemy3.physicsBody!.contactTestBitMask = PhysicsCatergories.Player | PhysicsCatergories.Bullet
        enemy3.position = startPoint
        enemy3.zPosition = 2
        self.addChild(enemy3)

        
        
        let moveEnemy = SKAction.move(to: endPoint, duration: 1.5)
        let moveEnemy2 = SKAction.move(to: endPoint2, duration: 1.5)
        let moveEnemy3 = SKAction.move(to: endPoint3, duration: 1.5)
        let deleteEnemy = SKAction.removeFromParent()
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy])
        let enemySequence2 = SKAction.sequence([moveEnemy2, deleteEnemy])
        let enemySequence3 = SKAction.sequence([moveEnemy3, deleteEnemy])
        
        if currentGameState == gameState.DuringGame{
            enemy1.run(enemySequence)
            enemy2.run(enemySequence2)
            enemy3.run(enemySequence3)

        }
        
        
    }
    
    func FragmentGoldAsteroid(FragPosition: CGPoint){
        let startPoint = FragPosition
        let randomXEnd = CGFloat.random(in: gameArea.minX..<gameArea.maxX)
        let randomXEnd2 = CGFloat.random(in: gameArea.minX..<gameArea.maxX)
        let randomXEnd3 = CGFloat.random(in: gameArea.minX..<gameArea.maxX)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        let endPoint2 = CGPoint(x: randomXEnd2, y: -self.size.height * 0.2)
        let endPoint3 = CGPoint(x: randomXEnd3, y: -self.size.height * 0.2)
        let enemy1 : SKSpriteNode
        enemy1 = SKSpriteNode(imageNamed: "Purple1")
        enemy1.name = "ROID"
        enemy1.physicsBody = SKPhysicsBody(circleOfRadius: enemy1.size.width)
        enemy1.physicsBody!.affectedByGravity = false
        enemy1.physicsBody!.categoryBitMask = PhysicsCatergories.PurpleDiamond
        enemy1.physicsBody!.collisionBitMask = PhysicsCatergories.Enemy | PhysicsCatergories.Bullet
        enemy1.physicsBody!.contactTestBitMask = PhysicsCatergories.Player | PhysicsCatergories.Bullet
        enemy1.position = startPoint
        enemy1.zPosition = 2
        self.addChild(enemy1)
        let enemy2 : SKSpriteNode
        enemy2 = SKSpriteNode(imageNamed: "Green1")
        enemy2.name = "ROID"
        enemy2.physicsBody = SKPhysicsBody(circleOfRadius: enemy2.size.width)
        enemy2.physicsBody!.affectedByGravity = false
        enemy2.physicsBody!.categoryBitMask = PhysicsCatergories.PurpleDiamond
        enemy2.physicsBody!.collisionBitMask = PhysicsCatergories.Enemy | PhysicsCatergories.Bullet
        enemy2.physicsBody!.contactTestBitMask = PhysicsCatergories.Player | PhysicsCatergories.Bullet
        enemy2.position = startPoint
        enemy2.zPosition = 2
        self.addChild(enemy2)
        let enemy3 : SKSpriteNode
        enemy3 = SKSpriteNode(imageNamed: "Blue1")
        enemy3.name = "ROID"
        enemy3.physicsBody = SKPhysicsBody(circleOfRadius: enemy3.size.width)
        enemy3.physicsBody!.affectedByGravity = false
        enemy3.physicsBody!.categoryBitMask = PhysicsCatergories.PurpleDiamond
        enemy3.physicsBody!.collisionBitMask = PhysicsCatergories.Enemy | PhysicsCatergories.Bullet
        enemy3.physicsBody!.contactTestBitMask = PhysicsCatergories.Player | PhysicsCatergories.Bullet
        enemy3.position = startPoint
        enemy3.zPosition = 2
        self.addChild(enemy3)

        
        let purpAnim = SKAction.animate(with:PurpleDiamondTextureArray, timePerFrame: 0.05)
        let greenAnim = SKAction.animate(with:GreenDiamondTextureArray, timePerFrame: 0.05)
        let blueAnim = SKAction.animate(with:BlueDiamondTextureArray, timePerFrame: 0.05)
        let purpAnim4eva = SKAction.repeatForever(purpAnim)
        let greenAnim4eva = SKAction.repeatForever(greenAnim)
        let blueAnim4eva = SKAction.repeatForever(blueAnim)
        let moveEnemy = SKAction.move(to: endPoint, duration: 1.5)
        let moveEnemy2 = SKAction.move(to: endPoint2, duration: 1.5)
        let moveEnemy3 = SKAction.move(to: endPoint3, duration: 1.5)
        let deleteEnemy = SKAction.removeFromParent()
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy])
        let enemySequence2 = SKAction.sequence([moveEnemy2, deleteEnemy])
        let enemySequence3 = SKAction.sequence([moveEnemy3, deleteEnemy])
        let PdSeq = SKAction.group([purpAnim4eva, enemySequence])
        let GdSeq = SKAction.group([greenAnim4eva, enemySequence2])
        let BdSeq = SKAction.group([blueAnim4eva, enemySequence3])

        
        if currentGameState == gameState.DuringGame{
            enemy1.run(PdSeq)
            enemy2.run(GdSeq)
            enemy3.run(BdSeq)

        }
        
        
    }
    
    
    
    func startNewLevel(){
        
        levelNumber += 1
        
        if self.action(forKey: "SpawningEnemies") != nil{
            self.removeAction(forKey: "SpawningEnemies")
        }
        
        var levelDuration = TimeInterval()
        
        switch levelNumber {
        case 1: levelDuration = 1
        case 2: levelDuration = 0.8
        case 3: levelDuration = 0.6
        case 4: levelDuration = 0.5
        case 5: levelDuration = 0.3
        default:
            levelDuration = 0.4
            print("Something went wrong with my level numbers")
        }
        
        let spawn = SKAction.run(SpawnEnemy)
        let waitToSpawn = SKAction.wait(forDuration: levelDuration)
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnLoop = SKAction.repeatForever(spawnSequence)
        self.run(spawnLoop, withKey: "SpawningEnemies")
        let second_wait = SKAction.wait(forDuration: 1)
        let check_boost = SKAction.run(CheckRocketStatus)
        let seq = SKAction.sequence([second_wait, check_boost])
        let seqLoop = SKAction.repeatForever(seq)
        self.run(seqLoop)
    }
    
    
    func CheckRocketStatus(){
        print(CurrentRocketMode)
        if CurrentRocketMode == RocketMode.Boosted{
            count -= 1
        }
        if CurrentRocketMode == RocketMode.DoubleXP {
            count -= 1
        }
        if CurrentRocketMode == RocketMode.BoostedDoubleXP{
            count -= 1
        }
        
        if count == 0{
            if CurrentRocketMode == RocketMode.Boosted{
                background.removeAction(forKey: "BoostBack")
                let anim =  SKAction.animate(with: BackgroundTextureArray, timePerFrame: 0.02)
                let anim4eva = SKAction.repeatForever(anim)
                let stan = SKAction.animate(with: PlayerShipTextureArray, timePerFrame: 0.1)
                let stan4eva = SKAction.repeatForever(stan)
                player.removeAction(forKey: "BOOST")
                player.run(stan4eva)
                background.run(anim4eva, withKey: "StanBack")
                CurrentRocketMode = RocketMode.Normal
            }
            if CurrentRocketMode == RocketMode.BoostedDoubleXP{
                background.removeAction(forKey: "BoostDoubleBack")
                let anim =  SKAction.animate(with: BackgroundTextureArray, timePerFrame: 0.02)
                let anim4eva = SKAction.repeatForever(anim)
                let stan = SKAction.animate(with: PlayerShipTextureArray, timePerFrame: 0.1)
                let stan4eva = SKAction.repeatForever(stan)
                player.removeAction(forKey: "BOOST")
                player.run(stan4eva)
                background.run(anim4eva, withKey: "StanBack")
                CurrentRocketMode = RocketMode.Normal
            }
            if CurrentRocketMode == RocketMode.DoubleXP{
                background.removeAction(forKey: "DoubleBack")
                let anim =  SKAction.animate(with: BackgroundTextureArray, timePerFrame: 0.02)
                let anim4eva = SKAction.repeatForever(anim)
                let stan = SKAction.animate(with: PlayerShipTextureArray, timePerFrame: 0.1)
                let stan4eva = SKAction.repeatForever(stan)
                player.removeAction(forKey: "BOOST")
                player.run(stan4eva)
                background.run(anim4eva, withKey: "StanBack")
                CurrentRocketMode = RocketMode.Normal
            }
            
            
            
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            let prevoiusTouch = touch.previousLocation(in: self)
            
            let difference = pointOfTouch.x - prevoiusTouch.x
            
            if currentGameState == gameState.DuringGame{
                if difference < 0 {CurrentPlayerRocketStatus = PlayerRocketStatus.TurningLeft}else{CurrentPlayerRocketStatus = PlayerRocketStatus.TurningRight}
            player.position.x  += difference
            }
            
            if player.position.x >= gameArea.maxX - player.size.width/2{
                player.position.x = gameArea.maxX - player.size.width/2
            }
            
            if player.position.x < gameArea.minX + player.size.width/2{
                player.position.x = gameArea.minX + player.size.width / 2
            }
        }
        
    }
}
