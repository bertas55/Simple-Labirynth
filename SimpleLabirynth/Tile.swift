//
//  Tile.swift
//  SimpleLabirynth
//
//  Created by Hubert on 28.06.2016.
//  Copyright © 2016 Hubert. All rights reserved.
//

import SpriteKit

class Tile : SKSpriteNode {
    static let size = (width: 18, height: 18)
    var type: TileType
    var coord: (x: Int, y: Int)

    init(type: TileType, coord: (x: Int, y: Int)) {
        self.type = type
        self.coord = coord

        //var texture = SKTexture(imageNamed: type.name)

        super.init(texture: nil, color: type.color, size: CGSize(width: type.size.width, height: type.size.height))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not beed implemented")
    }
}
