//
//  TileType.swift
//  SimpleLabirynth
//
//  Created by Hubert on 28.06.2016.
//  Copyright © 2016 Hubert. All rights reserved.
//

import SpriteKit

enum TileType {
    case Wall, Ground, Player, Path

    var name: String {
        switch self {
        case .Wall: return "wall"
        case .Ground: return "ground"
        case .Player: return "player"
        case .Path: return "path"
        }
    }

    var color: SKColor {
        switch self {
        case .Wall: return SKColor(red: 38/255, green: 35/255, blue: 58/255, alpha: 1)
        case .Player: return SKColor(red: 205/255, green: 85/255, blue: 78/255, alpha: 1)
        case .Path: return SKColor(red: 0/255, green: 183/255, blue: 152/255, alpha: 1)
        case .Ground: return SKColor(red: 0/255, green: 134/255, blue: 128/255, alpha: 1)
        }
    }

    var size: (width: Int, height: Int) {
        return (18, 18)
    }
}