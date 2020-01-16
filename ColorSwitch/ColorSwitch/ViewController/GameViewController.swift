//
//  GameViewController.swift
//  ColorSwitch
//
//  Created by Yaroslav Lebedev on 10/12/2018.
//  Copyright © 2018 Yaroslav Lebedev. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            let scene = MenuScene(size: view.bounds.size)
                scene.scaleMode = .aspectFill
            
                view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
}
