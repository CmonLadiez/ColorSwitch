//
//  MenuScene.swift
//  ColorSwitch
//
//  Created by Yaroslav Lebedev on 14/12/2018.
//  Copyright © 2018 Yaroslav Lebedev. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {

    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 75/255, green: 68/255, blue: 56/255, alpha: 1.0)
        addLogo()
        addLabels()
    }
    
    func addLogo() {
        let logo = SKSpriteNode(imageNamed: "logo")
        logo.size = CGSize(width: frame.width / 4, height: frame.width / 4)
        logo.position = CGPoint(x:frame.midX, y:frame.midY + frame.size.height / 4)
        
        let sndLogo = SKSpriteNode(imageNamed: "logo")
        sndLogo.size = CGSize(width: frame.width / 10, height: frame.width / 10)
        sndLogo.position = CGPoint(x:frame.midX - 2, y:frame.midY + frame.size.height / 13)
        
        addChild(logo)
        addChild(sndLogo)
        
        logo.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi/2, duration: 0.95)))
        sndLogo.run(SKAction.repeatForever(SKAction.rotate(byAngle: -.pi/2, duration: 0.95)))
    }
    
    func repeatPulse(x:SKLabelNode) {
        
        let pulseUp = SKAction.scale(to: 1.5, duration:0.6)
        let pulseDown = SKAction.scale(to: 0.8, duration:0.5)
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        let repeatpulse = SKAction.repeatForever(pulse)
        x.run(repeatpulse)
    }
    
    func addLabels() {
        
        let colorLabel = SKLabelNode(text: "Col  r")
        colorLabel.fontName = "GillSans-Bold"
        colorLabel.fontSize = 63
        colorLabel.fontColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1)
        colorLabel.position = CGPoint(x:frame.midX - 38, y:frame.midY + 50)
        addChild(colorLabel)
        
        let switchLabel = SKLabelNode(text: "Switch")
        switchLabel.fontName = "GillSans-Bold"
        switchLabel.fontSize = 63
        switchLabel.fontColor = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1)
        switchLabel.position = CGPoint(x:frame.midX + 38, y:frame.midY - colorLabel.frame.size.height + 50)
        addChild(switchLabel)

        let playLabel = SKLabelNode(text: "Tap To Play!")
        playLabel.fontName = "AvenirNext-Bold"
        playLabel.fontSize = 30
        playLabel.fontColor = UIColor.red
        playLabel.position = CGPoint(x:frame.midX, y:frame.midY - colorLabel.frame.size.height*3.6)
        addChild(playLabel)
        repeatPulse(x: playLabel)
        
        let highScoreLabel = SKLabelNode(text: "HighScore: " + "\(UserDefaults.standard.integer(forKey:"HighScore"))")
        highScoreLabel.numberOfLines = 2
        highScoreLabel.fontName = "GillSans-Bold"
        highScoreLabel.fontSize = 45
        highScoreLabel.fontColor = UIColor.white
        highScoreLabel.position = CGPoint(x:frame.midX, y:frame.midY - highScoreLabel.frame.size.height*5.1)
        addChild(highScoreLabel)
        
        /*
        let recentScoreLabel = SKLabelNode(text: "Recent Score:")
        recentScoreLabel.fontName = "AvenirNext-Bold"
        recentScoreLabel.fontSize = 38
        recentScoreLabel.fontColor = UIColor.white
        recentScoreLabel.position = CGPoint(x:frame.midX, y:frame.midY - highScoreLabel.position.y - recentScoreLabel.frame.size.height*2)
        addChild(recentScoreLabel)
 */
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let gameScene = GameScene(size: view!.bounds.size)
        self.view?.presentScene(gameScene, transition: SKTransition.push(with: SKTransitionDirection.up, duration: 0.3))
    }
}
