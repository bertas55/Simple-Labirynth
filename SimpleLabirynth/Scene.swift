//
//  Scene.swift
//  SimpleLabirynth
//
//  Created by Hubert on 22.06.2016.
//  Copyright © 2016 Hubert. All rights reserved.
//

import SpriteKit

class Scene: SKScene {

    var tileMap: TileMap!
    let tileSize: CGSize
    let mapSize: CGSize
    let controllButtonSize: CGSize

    var buttonUp: SKSpriteNode?
    var buttonDown: SKSpriteNode?
    var buttonRight: SKSpriteNode?
    var buttonLeft: SKSpriteNode?
    var buttonCheat: SKSpriteNode?


    override init(size: CGSize) {

        self.tileSize = CGSize(width: 18, height: 18)
        self.mapSize = CGSize(width: 23, height: 29)
        self.controllButtonSize = CGSize(width: 58, height: 58)

        super.init(size: size)

        self.tileMap = TileMap(mapSize: mapSize, tileSize: tileSize)

        backgroundColor = SKColor(red: 38/255, green: 35/255, blue: 58/255, alpha: 1)

        tileMap.position = CGPoint(x: 0, y: 5 * tileSize.height)
        addChild(tileMap)

        createPlayer()

        setupButtons()


    }

    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not beed implemented")
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let position: CGPoint = convertPointFromView(touch.locationInView(view))
            print(position.x, " ", position.y)

            let tilePosition = tileMap.tileCoordForPosition(position)
            print(tilePosition)

            if buttonUp!.containsPoint(position) {

                movePlayer(Direction.Up)
                print("button up")

            } else if buttonDown!.containsPoint(position) {

                movePlayer(Direction.Down)
                print("button down")

            } else if buttonRight!.containsPoint(position) {

                movePlayer(Direction.Right)
                print("button right")

            } else if buttonLeft!.containsPoint(position) {
                
                movePlayer(Direction.Left)
                print("button left")
                
            } else if buttonCheat!.containsPoint(position) {

                let qualityOfServiceClass = QOS_CLASS_BACKGROUND
                let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)

                /*
                dispatch_async(backgroundQueue, {
                    print("This is run on the background queue")


                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        print("This is run on the main queue, after the previous code in outer block")
                    })
                })
 */

                let path = tileMap.findShortestPathToExit((x: Int(self.tileMap.player!.coord.x), y: Int(self.tileMap.player!.coord.y)), exitCoords: (x: Int(tileMap.exitCoords.x), y: Int(tileMap.exitCoords.y)))
                showPath(path)
                print("button left")

                let delay = 3 * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue()) {
                    self.enumerateChildNodesWithName("Path", usingBlock: { node,_ in
                        node.removeFromParent()
                    })
                    
                }

            }
        }
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if tileMap.player?.coord == tileMap.exitCoords {
            let gameOverScene = GameOverScene(size: self.size)
            self.view?.presentScene(gameOverScene)
        }
    }

    private func showPath(path: [(x: Int, y: Int)]) {

        for i in path {
            let tile = Tile(type: TileType.Path, coord: CGPoint(x: i.x, y: i.y))
            let tilePositionInMap = tileMap.tilePositionForCoord(CGPoint(x: i.x, y: i.y))
            tile.position.x = tileMap.position.x + tilePositionInMap.x
            tile.position.y = tileMap.position.y + tilePositionInMap.y
            tile.zPosition = 100
            tile.name = "Path"
            
            self.addChild(tile)

        }




    }

    private func createPlayer() {
        let currentPoint = tileMap.tileCoordForPosition(CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame)))
        let directions = [Direction.Left, Direction.Down, Direction.Right, Direction.Up, Direction.LeftDown, Direction.LeftUp, Direction.RightDown, Direction.RightUp]
        var playerPosition: CGPoint?



        // 
        for i in 0..<directions.count {
            let dir = directions[i]
            let x = Int(currentPoint.x) + dir.dx
            let y = Int(currentPoint.y) + dir.dy

            if tileMap.tiles[y][x]?.type == TileType.Ground {
                playerPosition = CGPoint(x: x, y: y)
                break
            }
        }

        self.tileMap.player = Tile(type: TileType.Player, coord: playerPosition!)
        self.tileMap.player?.position = tileMap.tilePositionForCoord(playerPosition!)
        self.tileMap.player?.zPosition = 200

        self.tileMap.addChild(self.tileMap.player!)

        

    }

    func setupButtons() {

        self.buttonUp = SKSpriteNode(imageNamed: "buttonUp")
        self.buttonUp!.position = CGPointMake(self.controllButtonSize.width / 2 + 15, self.controllButtonSize.height * 1.5)
        self.buttonUp!.name = "buttonUp"
        self.buttonUp!.zPosition = 10

        self.addChild(self.buttonUp!)

        self.buttonDown = SKSpriteNode(imageNamed: "buttonDown")
        self.buttonDown!.position = CGPointMake(self.controllButtonSize.width / 2 + 15, self.controllButtonSize.height / 2)
        self.buttonDown!.name = "buttonDown"
        self.buttonDown!.zPosition = 10

        self.addChild(self.buttonDown!)

        self.buttonRight = SKSpriteNode(imageNamed: "buttonRight")
        self.buttonRight!.position = CGPointMake(CGRectGetMaxX(self.frame) - self.controllButtonSize.width / 2, self.controllButtonSize.height)
        self.buttonRight!.name = "buttonRight"
        self.buttonRight!.zPosition = 10

        self.addChild(self.buttonRight!)

        self.buttonLeft = SKSpriteNode(imageNamed: "buttonLeft")
        self.buttonLeft!.position = CGPointMake(CGRectGetMaxX(self.frame) - self.controllButtonSize.width * 1.5, self.controllButtonSize.height)
        self.buttonLeft!.name = "buttonLeft"
        self.buttonLeft!.zPosition = 10

        self.addChild(self.buttonLeft!)

        self.buttonCheat = SKSpriteNode(imageNamed: "buttonCheat")
        self.buttonCheat!.position = CGPointMake(CGRectGetMidX(self.frame), self.controllButtonSize.height)
        self.buttonCheat!.name = "buttonCheat"
        self.buttonCheat!.zPosition = 10

        self.addChild(self.buttonCheat!)

    }


    func movePlayer(direction: Direction) {

        let player = tileMap.player!

        var destinationPoint: CGPoint
        var delta: CGVector

        switch direction {
        case .Up:
            destinationPoint = CGPointMake(player.position.x, player.position.y + tileSize.height)
            delta = CGVector(dx: 0, dy: tileSize.height)
        case .Down:
            destinationPoint = CGPointMake(player.position.x, player.position.y - tileSize.height)
            delta = CGVector(dx: 0, dy: -tileSize.height)
        case .Left:
            destinationPoint = CGPointMake(player.position.x - tileSize.width, player.position.y)
            delta = CGVector(dx: -tileSize.width, dy: 0)
        case .Right:
            destinationPoint = CGPointMake(player.position.x + tileSize.width, player.position.y)
            delta = CGVector(dx: tileSize.width, dy: 0)
        default:
            destinationPoint = CGPointMake(player.position.x, player.position.y)
            delta = CGVector(dx: 0, dy: 0)

        }

        if !isCollision(destinationPoint) {
            player.coord = tileMap.tileCoordForPosition(destinationPoint)

            let moveAction = SKAction.moveBy(delta, duration: 0.1)


            player.runAction(moveAction)

            
            //player.position = destinationPoint
        }
    }

    func isCollision(coord: CGPoint) -> Bool {

        let mapPoint = tileMap.tileCoordForPosition(coord)
        let x = Int(mapPoint.x)
        let y = Int(mapPoint.y)

        if tileMap.tiles[y][x]?.type == TileType.Wall {
            return true
        } else {
            return false
        }
    }



}
