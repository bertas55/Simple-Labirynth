//
//  MazeBuilder.swift
//  SimpleLabirynth
//
//  Created by Hubert on 23.06.2016.
//  Copyright © 2016 Hubert. All rights reserved.
//

import SpriteKit

enum Direction: Int {
    case Left = 0, Down, Right, Up, LeftUp, LeftDown, RightUp, RightDown

    static func random() -> Direction {
        let randomInt = Int(arc4random_uniform(4))

        return Direction(rawValue: randomInt)!
    }

    var dx: Int {
        switch self {
        case .Up, .Down: return 0
        case .Right, .RightUp, .RightDown: return 1
        case .Left, .LeftUp, .LeftDown: return -1
        }
    }

    var dy: Int {
        switch self {
        case .Right, .Left: return 0
        case .Up, .LeftUp, .RightUp: return 1
        case .Down, .LeftDown, .RightDown: return -1
        }
    }
}


class MazeBuilder {

    // MARK: Type


    var maze: TileMap?

    // MARK: Initialization

    init(maze: TileMap) {
        self.maze = maze
    }


    // MARK: Methods

    func createMaze(width: Int, height: Int) -> TileMap {
        

        return TileMap(mapSize: CGSize(width: 3, height: 3), tileSize: CGSize(width: 3, height: 3))
    }


}

