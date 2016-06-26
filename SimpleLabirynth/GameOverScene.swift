//
//  GameOverScene.swift
//  SimpleLabirynth
//
//  Created by Hubert on 26.06.2016.
//  Copyright © 2016 Hubert. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {

    private let buttonRestart: SKSpriteNode

    override init(size: CGSize) {
        self.buttonRestart = SKSpriteNode(imageNamed: "buttonRestart")


/*
             self.buttonUp = SKSpriteNode(imageNamed: "buttonUp")
             self.buttonUp!.position = CGPointMake(CGRectGetMidX(self.frame), 64)
             self.buttonUp!.name = "buttonUp"
             self.buttonUp!.zPosition = 10

             self.addChild(self.buttonUp!)
 */

        super.init(size: size)

        self.buttonRestart.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.buttonRestart.name = "buttonRestart"

        self.addChild(self.buttonRestart)

        backgroundColor = SKColor(red: 38/255, green: 35/255, blue: 58/255, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let position: CGPoint = convertPointFromView(touch.locationInView(view))

            if buttonRestart.containsPoint(position) {
                let gameScene = Scene(size: self.size)
                self.view?.presentScene(gameScene)

            }
        }
    }
}
