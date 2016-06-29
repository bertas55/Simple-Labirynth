//
//  TileMap.swift
//  SimpleLabirynth
//
//  Created by Hubert on 22.06.2016.
//  Copyright © 2016 Hubert. All rights reserved.
//

import SpriteKit

class TileMap : SKNode {
    
    let mapSize: (width: Int, height: Int)
    var tiles = Array<Array<Tile?>>()
    let tileLayer = SKNode()
    var exitCoords: (x: Int, y: Int)

    init(mapSize: (width: Int, height: Int)) {

        self.mapSize = mapSize

        // 0 - left, 1 - right, 2 - up, 3 - down
        let side = arc4random_uniform(UInt32(4))
        var x, y: Int

        switch side {
        case 0:
            x = 0
            y = Int(arc4random_uniform(UInt32(mapSize.height - 2))) + 1
        case 1:
            x = Int(mapSize.width) - 1
            y = Int(arc4random_uniform(UInt32(mapSize.height - 2))) + 1
        case 2:
            x = Int(arc4random_uniform(UInt32(mapSize.width - 2))) + 1
            y = 0
        case 3:
            x = Int(arc4random_uniform(UInt32(mapSize.width - 2))) + 1
            y = Int(mapSize.height) - 1
        default:
            x = 0
            y = 1
        }

        self.exitCoords = (x, y)

        super.init()

        addChild(tileLayer)

        for _ in 0...(Int(mapSize.height) - 1) {
            tiles.append(Array(count: Int(mapSize.width), repeatedValue: nil))
        }

        createMap()
    }

    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not beed implemented")
    }

    func findShortestPathToExit(playerCoords: (x: Int, y: Int), exitCoords: (x: Int, y: Int)) -> [(x: Int, y: Int)] {
        var path = [(x: Int, y: Int)]()
        let directions = [Direction.Left, Direction.Down, Direction.Right, Direction.Up]
        var found = false

        var queue = Queue<(x: Int, y: Int)>()
        var distances = Array<Array<Int>>()

        for _ in 0...(Int(mapSize.height) - 1) {
            distances.append(Array(count: Int(mapSize.width), repeatedValue: -1))
        }

        queue.push(playerCoords)
        distances[playerCoords.y][playerCoords.x] = 0

        while !queue.isEmpty() && !found {
            let current = queue.pop()

            for i in 0..<directions.count {
                let dir = directions[i]
                let x = current.x + dir.dx
                let y = current.y + dir.dy

                if 0...Int(self.mapSize.width - 1) ~= x
                    && 0...Int(self.mapSize.height - 1) ~= y
                    && tiles[y][x]?.type != TileType.Wall
                    && distances[y][x] == -1 {
                    distances[y][x] = distances[current.y][current.x] + 1

                    if (x, y) == exitCoords {
                        found = true
                        break
                    }

                    queue.push((x, y))
                }
            }
        }

        var current = (x: exitCoords.x, y: exitCoords.y)
        path.append(current)

        for _ in 0...distances[exitCoords.y][exitCoords.x] {
            for j in 0..<directions.count {
                let dir = directions[j]
                let x = current.x + dir.dx
                let y = current.y + dir.dy

                if 1...Int(self.mapSize.width - 1) ~= x
                    && 1...Int(self.mapSize.height - 1) ~= y
                    && distances[y][x] == distances[current.y][current.x] - 1
                    && tiles[y][x]?.type != TileType.Wall {
                    path.append((x, y))
                    current = (x, y)
                }
            }

        }

        return path.reverse()
    }


    func tilePositionForCoord(coord: (x: Int, y: Int)) -> CGPoint {

        let x = Tile.size.width * coord.x + Tile.size.width / 2
        let y = Tile.size.height * coord.y + Tile.size.height / 2

        return CGPoint(x: x, y: y)
    }

    func tileCoordForPosition(tileMapPosition: (x: Int, y: Int)) -> (x: Int, y: Int) {

        let mapPosition = convertPoint(CGPoint(x: tileMapPosition.x, y: tileMapPosition.y), toNode: tileLayer)

        let x = Int(round(mapPosition.x / CGFloat(Tile.size.width)))
        let y = Int(round(mapPosition.y / CGFloat(Tile.size.height)))
        
        return (x, y)
    }


    private func createMap() {

        for y in 0...Int(mapSize.height - 1) {
            for x in 0...Int(mapSize.width - 1) {
                let coord = (x: x, y: y)
                tiles[y][x] = Tile(type: TileType.Wall, coord: coord)
                let tilePosition = tilePositionForCoord(coord)
                tiles[y][x]!.position = CGPoint(x: tilePosition.x, y: tilePosition.y)
            }
        }

        // Setting exit tile
        tiles[Int(self.exitCoords.y)][Int(self.exitCoords.x)] = Tile(type: TileType.Ground, coord: self.exitCoords)

        let tilePosition = tilePositionForCoord(exitCoords)
        tiles[Int(self.exitCoords.y)][Int(self.exitCoords.x)]!.position = CGPoint(x: tilePosition.x, y: tilePosition.y)

        carve(Int(self.exitCoords.x), y: Int(self.exitCoords.y))

        for y in 0...Int(mapSize.height - 1) {
            for x in 0...Int(mapSize.width - 1) {
                addChild(tiles[y][x]!)
            }
        }
    }

    private func carve(x: Int, y: Int) {

        let upx = [1, -1, 0, 0]
        let upy = [0, 0, 1, -1]
        var dir = Int(arc4random_uniform(4))
        var count = 0

        while count < 4 {
            let x1 = x + upx[dir]
            let y1 = y + upy[dir]
            let x2 = x1 + upx[dir]
            let y2 = y1 + upy[dir]


            if 1...Int(self.mapSize.width - 2) ~= x1 && 1...Int(self.mapSize.width - 2) ~= x2
                && 1...Int(self.mapSize.height - 2) ~= y1 && 1...Int(self.mapSize.height - 2) ~= y2
                && tiles[y1][x1]?.type == TileType.Wall && tiles[y2][x2]?.type == TileType.Wall {

                tiles[y1][x1] = Tile(type: TileType.Ground, coord: (x1, y1))
                tiles[y1][x1]!.position = tilePositionForCoord((x: x1, y: y1))

                tiles[y2][x2] = Tile(type: TileType.Ground, coord: (x2, y2))
                tiles[y2][x2]!.position = tilePositionForCoord((x2, y2))

                carve(x2, y: y2)
            } else {
                dir = (dir + 1) % 4
                count += 1
            }
        }
    }

}
