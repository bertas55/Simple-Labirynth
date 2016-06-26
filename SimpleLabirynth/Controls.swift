//
//  Controls.swift
//  SimpleLabirynth
//
//  Created by Hubert on 22.06.2016.
//  Copyright © 2016 Hubert. All rights reserved.
//

import SpriteKit

class Controls: SKScene {
    var button: SKNode! = nil

    override func didMoveToView(view: SKView) {
        // Create a simple red rectangle that's 100x44
        button = SKSpriteNode(color: SKColor.redColor(), size: CGSize(width: 100, height: 44))
        // Put it in the center of the scene
        button.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));

        self.addChild(button)
    }

}

class Button: SKNode {

    let sprite: SKSpriteNode
    let texture: SKTexture
    let coord: CGPoint

    init(coord: CGPoint, size: CGSize, texture: SKTexture) {

        self.texture = texture
        self.coord = coord
        sprite = SKSpriteNode(texture: texture, size: size)

        super.init()

        addChild(sprite)
    }

    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not beed implemented")
    }

}
