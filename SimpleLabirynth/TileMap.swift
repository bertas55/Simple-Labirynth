//
//  TileMap.swift
//  SimpleLabirynth
//
//  Created by Hubert on 22.06.2016.
//  Copyright © 2016 Hubert. All rights reserved.
//

import SpriteKit

// MARK: TyleType

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

    var size: CGSize {
        return CGSize(width: 18, height: 18)
    }
}

struct Queue<Element> {
    var items = [Element]()
    mutating func push(item: Element) {
        items.insert(item, atIndex: 0)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }

    func isEmpty() -> Bool {
        return items.isEmpty
    }
}

/// MARK: Tile

class Tile : SKSpriteNode {
    static let size = CGSize(width: 18, height: 18)
    var type: TileType
    var coord: CGPoint

    init(type: TileType, coord: CGPoint) {
        self.type = type
        self.coord = coord

        //var texture = SKTexture(imageNamed: type.name)

        super.init(texture: nil, color: type.color, size: type.size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not beed implemented")
    }
}

/// MARK: TileMap

class TileMap : SKNode {

    let mapSize: CGSize
    var tiles = Array<Array<Tile?>>()
    let tileLayer = SKNode()
    var exitCoords: CGPoint

    init(mapSize: CGSize) {

        self.mapSize = mapSize

        // Exit coordinates
        let y = Int(arc4random_uniform(UInt32(mapSize.height - 2))) + 1
        let x = 0
        self.exitCoords = CGPoint(x: x, y: y)

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

    private func createMap() {

        for y in 0...Int(mapSize.height - 1) {
            for x in 0...Int(mapSize.width - 1) {
                let coord = CGPoint(x: x, y: y)
                tiles[y][x] = Tile(type: TileType.Wall, coord: coord)
                tiles[y][x]!.position = tilePositionForCoord(coord)
            }
        }

        // Setting exit tile
        tiles[Int(self.exitCoords.y)][Int(self.exitCoords.x)] = Tile(type: TileType.Ground, coord: self.exitCoords)
        tiles[Int(self.exitCoords.y)][Int(self.exitCoords.x)]!.position = tilePositionForCoord(exitCoords)

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

                tiles[y1][x1] = Tile(type: TileType.Ground, coord: CGPoint(x: x1, y: y1))
                tiles[y1][x1]!.position = tilePositionForCoord(CGPoint(x: x1, y: y1))

                tiles[y2][x2] = Tile(type: TileType.Ground, coord: CGPoint(x: x2, y: y2))
                tiles[y2][x2]!.position = tilePositionForCoord(CGPoint(x: x2, y: y2))

                carve(x2, y: y2)
            } else {
                dir = (dir + 1) % 4
                count += 1
            }
        }
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



    func tilePositionForCoord(coord: CGPoint) -> CGPoint {

        let x = Tile.size.width * coord.x + Tile.size.width / 2
        let y = Tile.size.height * coord.y + Tile.size.height / 2

        return CGPoint(x: x, y: y)
    }

    func tileCoordForPosition(tileMapPosition: CGPoint) -> CGPoint {

        let mapPosition = convertPoint(tileMapPosition, toNode: tileLayer)

        let x = Int(mapPosition.x / Tile.size.width)
        let y = Int(mapPosition.y / Tile.size.height)
        
        return CGPoint(x: x, y: y)
    }

}











