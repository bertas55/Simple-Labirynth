//
//  GameOverScene.swift
//  SimpleLabirynth
//
//  Created by Hubert on 26.06.2016.
//  Copyright © 2016 Hubert. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {

    override init(size: CGSize) {
        super.init(size: size)

        backgroundColor = SKColor.cyanColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
