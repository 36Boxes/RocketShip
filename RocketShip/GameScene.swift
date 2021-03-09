//
//  GameScene.swift
//  RocketShip
//
//  Created by Josh Manik on 08/03/2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var levelNumber = 0
    var userScore = 0
    let ScoreLabel = SKLabelNode(fontNamed: "The Bold Font")
    
    var lives = 3
    let LivesLabel = SKLabelNode(fontNamed: "The Bold Font")
    
    // Adding the player to the scene
    
    let player = SKSpriteNode(imageNamed: "playerShip")

    struct PhysicsCatergories {
        static let None: UInt32 = 0
        
        static let Player: UInt32 = 0b1 //Binary for 1
        
        static let Bullet: UInt32 = 0b10 //Binary for 2
        
        static let Enemy: UInt32 = 0b100 // Binary for 4
    }
    
    
    
    
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
        
        self.physicsWorld.contactDelegate = self
        
        // Adding the background to the scene
        
        let background = SKSpriteNode(imageNamed: "background")
        background.size = CGSize (width: frame.maxX, height: frame.maxY)
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
                
        player.setScale(1)
        
        // We times the height by 0.2 as we want the ship to start 20% up from the bottom
        
        player.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.2)
        player.zPosition = 2
        self.addChild(player)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.affectedByGravity = false
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
        startNewLevel()
        
    }
    
    func loselives(){
        lives -= 1
        LivesLabel.text = "Lives : \(lives)"
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let sequence = SKAction.sequence([scaleUp, scaleDown])
        LivesLabel.run(sequence)
    }
    
    func addScore(){
        
        userScore += 1
        ScoreLabel.text = "Score: \(userScore)"
        
        if userScore == 10 || userScore == 25 || userScore == 50{
            startNewLevel()
        }
    }
    
    // Fire Bullet function
    
    func ShootBullet() {
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.setScale(1)
        bullet.position = player.position
        bullet.zPosition = 1
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
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
        
        let randomXStart = CGFloat.random(in: gameArea.minX - 30..<gameArea.maxX + 40)
        let randomXEnd = CGFloat.random(in: gameArea.minX - 30..<gameArea.maxX + 40)
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        let enemy = SKSpriteNode(imageNamed: "enemyShip")
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCatergories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCatergories.Enemy
        enemy.physicsBody!.contactTestBitMask = PhysicsCatergories.Player | PhysicsCatergories.Bullet
        self.addChild(enemy)
        
        let moveEnemy = SKAction.move(to: endPoint, duration: 1.5)
        let deleteEnemy = SKAction.removeFromParent()
        let wellDoneSoldier = SKAction.run(loselives)
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy, wellDoneSoldier])
        enemy.run(enemySequence)
        
        let diffX = endPoint.x - startPoint.x
        let diffY = endPoint.y - startPoint.y
        let amount2Rotate = atan2(diffY, diffX)
        enemy.zRotation = amount2Rotate
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        ShootBullet()

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
            
            if body1.node != nil{Explode(explodeposition: body1.node!.position)}
            if body2.node != nil{Explode(explodeposition: body2.node!.position)}

            body1.node?.removeFromParent()
            body2.node?.removeFromParent()

            
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
    }
    
    func Explode(explodeposition: CGPoint){
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
            
            player.position.x  += difference
            
            if player.position.x >= gameArea.maxX - player.size.width/2{
                player.position.x = gameArea.maxX - player.size.width/2
            }
            
            if player.position.x < gameArea.minX + player.size.width/2{
                player.position.x = gameArea.minX + player.size.width / 2
            }
        }
        
    }
}
