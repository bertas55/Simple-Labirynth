//
//  Player.swift
//  SimpleLabirynth
//
//  Created by Hubert on 27.06.2016.
//  Copyright © 2016 Hubert. All rights reserved.
//

import SpriteKit

class Player: Tile {

    unowned private let tileMap: TileMap

    init(tileMap: TileMap) {

        self.tileMap = tileMap

        // Position in center of tileMap
        let currentCoord = (x: Int(tileMap.mapSize.width / 2), y: Int(tileMap.mapSize.height / 2))
        var playerPosition = (x: 0, y: 0)

        let directions = [Direction.Left, Direction.Down, Direction.Right, Direction.Up, Direction.LeftDown, Direction.LeftUp, Direction.RightDown, Direction.RightUp]

        for dir in directions {
            let x = currentCoord.x + dir.dx
            let y = currentCoord.y + dir.dy

            if tileMap.tiles[y][x]?.type == TileType.Ground {
                playerPosition = (x: x, y: y)
                break
            }
        }

        super.init(type: TileType.Player, coord: playerPosition)

        self.position = tileMap.tilePositionForCoord(playerPosition)
        self.zPosition = 200
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func move(direction: Direction) {

        var destinationPoint: (x: Int, y: Int)

        switch direction {
        case .Up:
            destinationPoint = (x: Int(self.position.x), y: Int(self.position.y) + Tile.size.height)
        case .Down:
            destinationPoint = (x: Int(self.position.x), y: Int(self.position.y) - Tile.size.height)
        case .Left:
            destinationPoint = (x: Int(self.position.x) - Tile.size.width, y: Int(self.position.y))
        case .Right:
            destinationPoint = (x: Int(self.position.x) + Tile.size.width, y: Int(self.position.y))
        default:
            destinationPoint = (x: Int(self.position.x), y: Int(self.position.y))
        }

        if !isCollision(destinationPoint) {
            self.coord = self.tileMap.tileCoordForPosition(destinationPoint)
            self.position = self.tileMap.tilePositionForCoord(self.coord)
        }
    }

    private func isCollision(coord: (x: Int, y: Int)) -> Bool {

        let mapPoint = tileMap.tileCoordForPosition(coord)
        let x = Int(mapPoint.x)
        let y = Int(mapPoint.y)

        return self.tileMap.tiles[y][x]?.type == TileType.Wall
    }
}
