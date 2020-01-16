//
//  GameScene.swift
//  ColorSwitch
//
//  Created by Yaroslav Lebedev on 10/12/2018.
//  Copyright © 2018 Yaroslav Lebedev. All rights reserved.
//
import SpriteKit

enum PlayColors {
    static let colors = [
    UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1),
    UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1),
    UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1),
    UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1),
    ]
}

enum SwitchState: Int {
    case green, blue, yellow, red
}

class GameScene: SKScene {
    
    var colorSwitch: SKSpriteNode!
    var switchState = SwitchState.green
    var currentColorIndex: Int?
    
    var score = 0
    let scoreLabel = SKLabelNode(text: "Score:0")
    var gameOverIndi = 0
    
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 75/255, green: 68/255, blue: 56/255, alpha: 1.0)
        setupPhysics()
        layoutScene()
    }
    
    func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -3)
        physicsWorld.contactDelegate = self
    }
    
    func layoutScene() {
        colorSwitch = SKSpriteNode(imageNamed: "ColorCircle")
        colorSwitch.size = CGSize(width: frame.size.width/3, height: frame.size.width/3)
        colorSwitch.position = CGPoint(x:frame.midX , y: frame.minY + colorSwitch.size.height)
        colorSwitch.zPosition = ZPositions.colorSwitch
        
        colorSwitch.physicsBody = SKPhysicsBody(circleOfRadius: colorSwitch.size.width/2)
        colorSwitch.physicsBody?.categoryBitMask = PhysicsCategories.switchCategory
        colorSwitch.physicsBody?.isDynamic = false
        addChild(colorSwitch)
        
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.fontSize = 46
        scoreLabel.fontColor = UIColor.init(white: 0.52, alpha: 0.26)
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        scoreLabel.zPosition = ZPositions.label
        addChild(scoreLabel)
        
        spawnBall()
    }
    
    func updateScoreLabel() {
        scoreLabel.text = "Score:\(score)"
    }
    
    func spawnBall() {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -3.1 - (0.65 * Double(score / 5)))
        currentColorIndex = Int(arc4random_uniform(UInt32(4)))
        
        let ball = SKSpriteNode(texture: SKTexture(imageNamed: "ball"), color: PlayColors.colors[currentColorIndex!],size: CGSize(width: 30, height: 30))
        ball.colorBlendFactor = 1.0
        ball.name = "Ball"
        ball.position = CGPoint(x:frame.midX, y: frame.maxY)
        ball.zPosition = ZPositions.ball
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        ball.physicsBody?.categoryBitMask = PhysicsCategories.ballCategory
        ball.physicsBody?.contactTestBitMask = PhysicsCategories.switchCategory
        ball.physicsBody?.collisionBitMask = PhysicsCategories.none
        
        
        addChild(ball)
    }
    
    func turnWheel() {
        if let newState = SwitchState(rawValue: switchState.rawValue + 1) {
            switchState = newState
        } else {
            switchState = .green
        }
        colorSwitch.run(SKAction.rotate(byAngle: .pi/2, duration: 0.1))
    }
    
    func GameOver() {
        if score > UserDefaults.standard.integer(forKey: "HighScore") {
            UserDefaults.standard.set(score, forKey: "HighScore")
            let highLabel  = SKLabelNode(text: "New Highscore")
            highLabel.fontName = "GillSans-Bold"
            highLabel.fontSize = 45
            highLabel.fontColor = UIColor.magenta
            highLabel.position = CGPoint(x:frame.midX, y:frame.minY)
            highLabel.zPosition = ZPositions.colorSwitch    //poverh
            addChild(highLabel)
            
            highLabel.run(SKAction.moveTo(y: frame.midY, duration: 0.6))
        }
        
        let overLabel  = SKLabelNode(text: "GAME OVER")
        overLabel.fontName = "GillSans-Bold"
        overLabel.fontSize = 56
        overLabel.fontColor = UIColor.red
        overLabel.position = CGPoint(x:frame.midX, y:frame.minY)
        overLabel.zPosition = ZPositions.colorSwitch    //poverh
        addChild(overLabel)
        
        overLabel.run(SKAction.moveTo(y: frame.midY + overLabel.frame.size.height * 4, duration: 0.6))
        
        let recentScoreLabel = SKLabelNode(text: "Your Score:\(score)")
        recentScoreLabel.numberOfLines = 2
        recentScoreLabel.fontName = "AvenirNext-Bold"
        recentScoreLabel.fontSize = 40
        recentScoreLabel.fontColor = UIColor.white
        recentScoreLabel.position = CGPoint(x:frame.midX, y:frame.minY)
        recentScoreLabel.zPosition = ZPositions.colorSwitch    //poverh
        addChild(recentScoreLabel)
        
        scoreLabel.removeFromParent()
        
        recentScoreLabel.run(SKAction.moveTo(y: frame.midY + overLabel.frame.size.height * 2, duration: 0.6), completion: {
            self.gameOverIndi = 1
            })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameOverIndi == 1 {
            //DispatchQueue.main.asyncAfter(deadline:.now() + 2) {
                let menuScene = MenuScene(size:view!.bounds.size)
            self.view?.presentScene(menuScene, transition: SKTransition.flipVertical(withDuration: 0.5))
           // }
        }
        turnWheel()
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        // 01
        //10
        //11
        let contactMask = contact.bodyA.categoryBitMask |
            contact.bodyB.categoryBitMask
        
        if contactMask == PhysicsCategories.ballCategory |
            PhysicsCategories.switchCategory {
            if let ball = contact.bodyA.node?.name == "Ball" ? contact.bodyA.node as? SKSpriteNode: contact.bodyB.node as? SKSpriteNode{
                if currentColorIndex == switchState.rawValue {
                    score+=1
                    updateScoreLabel()
                    ball.run(SKAction.fadeOut(withDuration: 0.1), completion: {
                        ball.removeFromParent()
                        self.spawnBall()
                    })
                } else {
                    GameOver()
                    colorSwitch.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi/2, duration: 0.95)))
                }
            }
            
        }
    }
}
