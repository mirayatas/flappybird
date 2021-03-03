//
//  GameScene.swift
//  flappybird
//
//  Created by miray on 12.06.2020.
//  Copyright © 2020 miray. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCatagory {
    static let HarleyQuinn : UInt32 = 0x1 << 1
    static let Ground : UInt32 = 0x1 << 2
    static let Wall : UInt32 = 0x1 << 3
    static let Score : UInt32 = 0x1 << 4
}




class GameScene: SKScene, SKPhysicsContactDelegate {
  
    
    var Ground = SKSpriteNode()
    var HarleyQuinn = SKSpriteNode()
    var wallPair = SKNode()
    var moveAndRemove = SKAction()
    var gameStarted = Bool()
    var Score = Int()
    let ScoreLabel = SKLabelNode()
    var death = Bool()
    var RestartButton = SKSpriteNode()

    func RestartScene(){
        self.removeAllChildren()
        self.removeAllActions()
        death = false
        gameStarted = false
        Score = 0
        CreateScene()
    }
    
    func CreateScene(){
        
                
         
               self.physicsWorld.contactDelegate = self
         
               for i in 0..<2{
        
               let background = SKSpriteNode(imageNamed: "Background")
               background.anchorPoint = CGPoint.zero
               let width = CGFloat(i)*self.frame.width
               background.position = CGPoint(x: width-400, y: (-(self.frame.height/4))-500)
               background.name = "background"
               self.addChild(background)
                        }
        
               
        
               ScoreLabel.position = CGPoint(x: 0, y: (-(self.frame.height/4))+700)
               ScoreLabel.text = "\(Score)"
               self.addChild(ScoreLabel)
               ScoreLabel.fontName = "04b_19"
               ScoreLabel.fontSize = 100
               ScoreLabel.zPosition = 6
        
        
               Ground = SKSpriteNode(imageNamed: "Ground") //Yeryüzü tanımlandı
               Ground.setScale(0.9)
               Ground.position = CGPoint(x: 0 , y: (-(self.frame.height/4))-500)
               Ground.physicsBody = SKPhysicsBody(rectangleOf: Ground.size)
               Ground.physicsBody?.categoryBitMask = PhysicsCatagory.Ground
               Ground.physicsBody?.collisionBitMask = PhysicsCatagory.HarleyQuinn
               Ground.physicsBody?.contactTestBitMask = PhysicsCatagory.HarleyQuinn
               Ground.physicsBody?.affectedByGravity = false
               Ground.physicsBody?.isDynamic = false
               Ground.zPosition = 3

               self.addChild(Ground)
               
               
               HarleyQuinn = SKSpriteNode(imageNamed: "HarleyQuinn") //Karakter tanımlandı
               HarleyQuinn.size = CGSize(width: 100, height: 100)
               HarleyQuinn.position = CGPoint(x: -(self.frame.width/4), y: 0)
               
               HarleyQuinn.physicsBody = SKPhysicsBody(circleOfRadius: HarleyQuinn.frame.height/4)
               HarleyQuinn.physicsBody?.categoryBitMask = PhysicsCatagory.HarleyQuinn
               HarleyQuinn.physicsBody?.collisionBitMask = PhysicsCatagory.Ground | PhysicsCatagory.Wall
               HarleyQuinn.physicsBody?.contactTestBitMask = PhysicsCatagory.Ground | PhysicsCatagory.Wall | PhysicsCatagory.Score
               HarleyQuinn.physicsBody?.affectedByGravity = false
               HarleyQuinn.physicsBody?.isDynamic = true
               HarleyQuinn.zPosition = 2
               
               self.addChild(HarleyQuinn)
        
                
        
                
           
    }
    
    override func didMove(to view: SKView) {
       CreateScene()
    }
    
   
    
    func CreateButton(){
        RestartButton = SKSpriteNode(imageNamed: "Restart")
        RestartButton.size = CGSize(width: 300, height: 170)
        RestartButton.position = CGPoint(x: 0, y: 0)
        RestartButton.zPosition = 6
        RestartButton.setScale(0)
        self.addChild(RestartButton)
        
        RestartButton.run(SKAction.scale(to: 1.0, duration: 2.0))
        
        
    }
    func GameOver(){
        var GameOver = SKLabelNode()
        GameOver = SKLabelNode(text: "GAME OVER")
        GameOver.position = CGPoint(x: 0, y: (-(self.frame.height/4))+500)
        GameOver.fontSize = 100
        self.addChild(GameOver)
        GameOver.fontName = "04b_19"
        GameOver.zPosition = 6
        
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        
        
        
        if firstBody.categoryBitMask == PhysicsCatagory.Score && secondBody.categoryBitMask == PhysicsCatagory.HarleyQuinn{
             Score += 10
             ScoreLabel.text = "\(Score)"
             firstBody.node?.removeFromParent()
            
        }
        else if firstBody.categoryBitMask == PhysicsCatagory.HarleyQuinn && secondBody.categoryBitMask == PhysicsCatagory.Score{
            
             Score += 10 //Skorun kaçar kaçar artacağını tanımladık.
             ScoreLabel.text = "\(Score)" //Skoru ekrana yazdırdık.
            secondBody.node?.removeFromParent()
        }
            
        
        
        else if firstBody.categoryBitMask == PhysicsCatagory.HarleyQuinn && secondBody.categoryBitMask == PhysicsCatagory.Wall || firstBody.categoryBitMask == PhysicsCatagory.Wall && secondBody.categoryBitMask == PhysicsCatagory.HarleyQuinn
        {  // Karakter duvarlara değerse oyunu yeniden başlat.
            
            enumerateChildNodes(withName: "wallPair", using: ({
                
                (node, error) in
                node.speed = 0
                self.removeAllActions()
            }))
            if death == false{
                death = true
                GameOver()
                CreateButton()
            }
              
            
        }
        
        
        
        
        
         else if firstBody.categoryBitMask == PhysicsCatagory.HarleyQuinn && secondBody.categoryBitMask == PhysicsCatagory.Ground || firstBody.categoryBitMask == PhysicsCatagory.Ground && secondBody.categoryBitMask == PhysicsCatagory.HarleyQuinn
               { // Karakter yere değerse oyunu yeniden başlat.
                   
                   enumerateChildNodes(withName: "wallPair", using: ({
                       
                       (node, error) in
                       node.speed = 0
                       self.removeAllActions()
                   }))
                   if death == false{
                       death = true
                       GameOver()
                       CreateButton()
                      
                   }
                     
                   
               }
        
    }
   
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStarted == false {
                gameStarted = true
                HarleyQuinn.physicsBody?.affectedByGravity = true
                let spawn = SKAction.run({
                    
                    () in
                    
                    self.createWalls()
                    
                })
                
                let delay = SKAction.wait(forDuration: 2.0)
                let SpawnDelay = SKAction.sequence([spawn, delay])
                let spawnDelayForever = SKAction.repeatForever(SpawnDelay)
                self.run(spawnDelayForever)
                
                let distance = CGFloat(((self.frame.width)*5) + wallPair.frame.width)
                let movePipes = SKAction.moveBy(x: -distance-50, y: 0.0, duration: TimeInterval(0.01*distance))
                let removePipes = SKAction.removeFromParent()
                moveAndRemove = SKAction.sequence([movePipes,removePipes])
                
                
                 HarleyQuinn.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                 HarleyQuinn.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 50))
                
        }
            
        else{
            
                    if death == true{
                
                                    }
            
                    else{
            
                            HarleyQuinn.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                            HarleyQuinn.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 50))
                        }
            }
        
        for touch in touches{
            let location = touch.location(in: self)
            if death == true{
                if RestartButton.contains(location){
                        RestartScene()
                }
            }
        }
    }
        
    func createWalls(){
        
        let scoreNode = SKSpriteNode(imageNamed: "Coin")
        
        scoreNode.size = CGSize(width: 100, height: 100) // Skor geçişlerinin boyutunu tanımladık
        scoreNode.position = CGPoint(x: 200, y: (-(self.frame.height/4))+350)
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.isDynamic = false
        scoreNode.physicsBody?.categoryBitMask = PhysicsCatagory.Score
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.contactTestBitMask = PhysicsCatagory.HarleyQuinn // ScoreNode ile karakteri bağladık
        
        
        wallPair = SKNode()
        wallPair.name = "wallPair"
        let topWall = SKSpriteNode(imageNamed: "Wall")
        let bottomWall = SKSpriteNode(imageNamed: "Wall")
        
        topWall.position = CGPoint(x:200, y: (-(self.frame.height/4))-220)
        bottomWall.position = CGPoint(x: 200, y: (self.frame.height/4)+220)
        bottomWall.size = CGSize(width: 100, height: 1300)
        topWall.size = CGSize(width: 100, height: 1300)
        topWall.setScale(0.6)
        bottomWall.setScale(0.6)

        
        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody?.categoryBitMask = PhysicsCatagory.Wall
        topWall.physicsBody?.collisionBitMask = PhysicsCatagory.HarleyQuinn
        topWall.physicsBody?.contactTestBitMask = PhysicsCatagory.HarleyQuinn
        topWall.physicsBody?.isDynamic = false
        topWall.physicsBody?.affectedByGravity = false
        
        bottomWall.physicsBody = SKPhysicsBody(rectangleOf: bottomWall.size)
        bottomWall.physicsBody?.categoryBitMask = PhysicsCatagory.Wall
        bottomWall.physicsBody?.collisionBitMask = PhysicsCatagory.HarleyQuinn
        bottomWall.physicsBody?.contactTestBitMask = PhysicsCatagory.HarleyQuinn
        bottomWall.physicsBody?.isDynamic = false
        bottomWall.physicsBody?.affectedByGravity = false
        
        topWall.zRotation = CGFloat(Double.pi)
        
        wallPair.addChild(topWall)
        wallPair.addChild(bottomWall)
        
        wallPair.zPosition = 1
        wallPair.run(moveAndRemove)
        
        var randomPosition = CGFloat.random(min: -200, max: 200)
        wallPair.position.y = wallPair.position.y + randomPosition
        wallPair.addChild(scoreNode)
        
        self.addChild(wallPair)
    }
        

    override func update(_ currentTime: TimeInterval) {
        
        
             if gameStarted == true {
                       if death == false {
                           enumerateChildNodes(withName: "background", using: ({
                               
                               (node, error) in
                               var background = node as! SKSpriteNode
                               background.position = CGPoint(x: background.position.x-5, y: background.position.y) //Arkaplan akış hızı
                               
                               if background.position.x <= -(background.size.width+20){
                                   background.position = CGPoint(x: background.position.x + background.size.width, y: background.position.y )                    }
                               
                           }))
                       }
        }
        
    }
        
    
        
}

