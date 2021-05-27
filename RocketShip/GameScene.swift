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
    let background = SKSpriteNode(imageNamed: "glitter-universe-1-1")
    var ticker = 0
    
    var lives = 3
    let LivesLabel = SKLabelNode(fontNamed: "ADAM.CGPRO")
    
    // Adding the player to the scene
    
    let player = SKSpriteNode(imageNamed: "RocketFlames")
    
    var FlameTimer : Timer!
    
    var BoostedTimer : Timer!
    
    var counter = 0
    
    enum gameState{
        
        case PreGame
        case DuringGame
        case GameFinished
        
    }
    
    var currentGameState = gameState.DuringGame

    struct PhysicsCatergories {
        
        static let None: UInt32 = 0
        
        static let Player: UInt32 = 1 //Binary for 1
        
        static let Bullet: UInt32 = 2 //Binary for 2
        
        static let Enemy: UInt32 = 4 // Binary for 4
        
        static let Asteroid: UInt32 = 8 //binary for 8
        
        static let DoublePoints: UInt32 = 16
        
        static let GoldCoin: UInt32 = 32
        
        static let AsteroidFragment: UInt32 = 64
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
    }
    
    var CurrentPlayerRocketStatus = PlayerRocketStatus.Straight
    var CurrentRocketMode = RocketMode.Normal
    
    
    
    
    let gameArea: CGRect
    
    override init(size: CGSize){
        
        // to have this work nicely on most devices i could maybe identify the device and then have the correct aspect ratio
        let maxAspectRatio: CGFloat = 1.9
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
        BackgroundAnimation = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(UpdateBackgroundTexture), userInfo: nil, repeats: true)
                
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
        
        FlameTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateFlameTexture), userInfo: nil, repeats: true)
        startNewLevel()
        
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
    
    
    @objc func UpdateFlameTexture(){
        
        if CurrentRocketMode == RocketMode.Normal{
            if CurrentPlayerRocketStatus == PlayerRocketStatus.TurningLeft{
                
                if flipper == 0{
                    player.texture = SKTexture(imageNamed: "RocketFlamesL" )
                    flipper = 2
                }else if flipper == 2{
                    player.texture = SKTexture(imageNamed: "RocketFlamesL2" )
                    flipper = 3
                }else{
                    player.texture = SKTexture(imageNamed: "RocketFlamesL3")
                    flipper = 0
                }
        
            }
            if CurrentPlayerRocketStatus == PlayerRocketStatus.TurningRight{
                
                if RightFlipper == 0{
                    player.texture = SKTexture(imageNamed: "RocketFlamesR" )
                    RightFlipper = 2
                }else if RightFlipper == 2{
                    player.texture = SKTexture(imageNamed: "RocketFlamesR2" )
                    RightFlipper = 3
                }else{
                    player.texture = SKTexture(imageNamed: "RocketFlamesR3")
                    RightFlipper = 0
                }
        
            }
            if CurrentPlayerRocketStatus == PlayerRocketStatus.Straight{
                
                if StraightFlipper == 0{
                    player.texture = SKTexture(imageNamed: "RocketFlames" )
                    StraightFlipper = 2
                }else if StraightFlipper == 2{
                    player.texture = SKTexture(imageNamed: "RocketFlamesS2" )
                    StraightFlipper = 3
                }else{
                    player.texture = SKTexture(imageNamed: "RocketFlamesS3")
                    StraightFlipper = 0
                }
        
            }
        }
            
        if CurrentRocketMode == RocketMode.Boosted{
            counter -= 1
            if counter < 0{ CurrentRocketMode = RocketMode.Normal}
            if CurrentPlayerRocketStatus == PlayerRocketStatus.TurningLeft{
                
                if flipper == 0{
                    player.texture = SKTexture(imageNamed: "BlueFlameL1" )
                    flipper = 2
                }else if flipper == 2{
                    player.texture = SKTexture(imageNamed: "BlueFlameL2" )
                    flipper = 3
                }else{
                    player.texture = SKTexture(imageNamed: "BlueFlameL1")
                    flipper = 0
                }
            
            }
            if CurrentPlayerRocketStatus == PlayerRocketStatus.TurningRight{
                    
                if RightFlipper == 0{
                    player.texture = SKTexture(imageNamed: "BlueFlameR1" )
                    RightFlipper = 2
                }else if RightFlipper == 2{
                    player.texture = SKTexture(imageNamed: "BlueFlameR2" )
                    RightFlipper = 3
                }else{
                    player.texture = SKTexture(imageNamed: "BlueFlameR1")
                    RightFlipper = 0
                }
        
            }
            if CurrentPlayerRocketStatus == PlayerRocketStatus.Straight{
                
            if StraightFlipper == 0{
                    player.texture = SKTexture(imageNamed: "BlueFlameS1" )
                    StraightFlipper = 2
                }else if StraightFlipper == 2{
                    player.texture = SKTexture(imageNamed: "BlueFlameS2" )
                    StraightFlipper = 3
                }else{
                    player.texture = SKTexture(imageNamed: "BlueFlameS1")
                    StraightFlipper = 0
                }
        
            }
        }
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
    
    func addScore(){
        userScore += 1
        ScoreLabel.text = "Score: \(userScore)"
        
        if userScore == 25 || userScore == 50 || userScore == 100{
            startNewLevel()
        }
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
    
    func DoubleScoreCoin(){
        let randomXStart = CGFloat.random(in: gameArea.minX..<gameArea.maxX)
        let randomXEnd = CGFloat.random(in: gameArea.minX..<gameArea.maxX)
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        let enemy = SKSpriteNode(imageNamed: "GoldCoin")
        enemy.name = "Double"
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCatergories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCatergories.Enemy
        enemy.physicsBody!.contactTestBitMask = PhysicsCatergories.Bullet
        self.addChild(enemy)
        
        let moveEnemy = SKAction.move(to: endPoint, duration: 0.5)
        let deleteEnemy = SKAction.removeFromParent()
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy])
        if currentGameState == gameState.DuringGame{
        enemy.run(enemySequence)
        }
        let diffX = endPoint.x - startPoint.x
        let diffY = endPoint.y - startPoint.y
        let amount2Rotate = atan2(diffY, diffX)
        enemy.zRotation = amount2Rotate
        
        
    }
    
    func SpawnEnemy(){
        
        let randomXStart = CGFloat.random(in: gameArea.minX..<gameArea.maxX)
        let randomXEnd = CGFloat.random(in: gameArea.minX..<gameArea.maxX)
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        let EnemyDecider = Int.random(in: 1..<4)
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
            let Lucky = Int.random(in: 1..<3)
            if Lucky == 2{
                enemy = SKSpriteNode(imageNamed: "GoldCoin")
                enemy.name = "DoubleXP"
                enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
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
       
        enemy.position = startPoint
        enemy.zPosition = 2
        self.addChild(enemy)
        
        let moveEnemy = SKAction.move(to: endPoint, duration: 1.5)
        let deleteEnemy = SKAction.removeFromParent()
        let wellDoneSoldier = SKAction.run(loselives)
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy, wellDoneSoldier])
        let coinSequence = SKAction.sequence([moveEnemy, deleteEnemy])
        if currentGameState == gameState.DuringGame{
            
            // We do this as only the enemy ships should take lives off the player
            
            if enemy.name == "OPPBOY"{
                enemy.run(enemySequence)
            }
            else{
                enemy.run(coinSequence)
            }
        }
        let diffX = endPoint.x - startPoint.x
        let diffY = endPoint.y - startPoint.y
        let amount2Rotate = atan2(diffY, diffX)
        enemy.zRotation = amount2Rotate
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        if currentGameState == gameState.DuringGame{
        ShootBullet()
            CurrentPlayerRocketStatus = PlayerRocketStatus.Straight
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
        
        // If the player hits the enemy
        
        if body1.categoryBitMask == PhysicsCatergories.Player && body2.categoryBitMask == PhysicsCatergories.Enemy{
            if CurrentRocketMode == RocketMode.Boosted{
                if body2.node != nil{Explode(explodeposition: body2.node!.position)}
                body2.node?.removeFromParent()
                addScore()
            }
            else{
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
            
            CurrentRocketMode = RocketMode.Boosted
            counter = 50
            AddBonus()
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
        
        // If the bullet hits the enemy
        if body1.categoryBitMask == PhysicsCatergories.Bullet && body2.categoryBitMask == PhysicsCatergories.Enemy{
            
            if body2.node != nil{
                // Check wether the enemy is on screen when the bullet makes contact
                if body2.node!.position.y > self.size.height{
                    return
                }else{
                    // we know this is on the screen so we want to show an explosion
                    Explode(explodeposition: body2.node!.position)
                    addScore()
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
            if CurrentRocketMode == RocketMode.Boosted{
                if body2.node != nil{Explode(explodeposition: body2.node!.position)}
                body2.node?.removeFromParent()
                addScore()
            }else{
            if body1.node != nil{Explode(explodeposition: body1.node!.position)}
            if body2.node != nil{Explode(explodeposition: body2.node!.position)}

            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            gameOver()
                
            }
            
        }
        
        // If the player hits an asteroid fragment
        if body1.categoryBitMask == PhysicsCatergories.Player && body2.categoryBitMask == PhysicsCatergories.AsteroidFragment{
            if CurrentRocketMode == RocketMode.Boosted{
                if body2.node != nil{Explode(explodeposition: body2.node!.position)}
                body2.node?.removeFromParent()
                addScore()
            }else{
            if body1.node != nil{Explode(explodeposition: body1.node!.position)}
            if body2.node != nil{Explode(explodeposition: body2.node!.position)}

            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            gameOver()
            }
        }
    }
    
    @objc func BoostedCountdown(){
        print(counter)
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
