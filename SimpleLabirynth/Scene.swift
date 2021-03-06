//
//  Scene.swift
//  SimpleLabirynth
//
//  Created by Hubert on 22.06.2016.
//  Copyright © 2016 Hubert. All rights reserved.
//

import SpriteKit

class Scene: SKScene {

    let tileMap: TileMap
    let player: Player
    let mapSize: (width: Int, height: Int)
    let controllButtonSize: (width: Int, height: Int)

    var buttonUp: SKSpriteNode?
    var buttonDown: SKSpriteNode?
    var buttonRight: SKSpriteNode?
    var buttonLeft: SKSpriteNode?
    var buttonCheat: SKLabelNode?


    override init(size: CGSize) {

        self.controllButtonSize = (width: 58, height: 58)
        self.mapSize = (width: Int(size.width) / Tile.size.width,
                              height: (Int(size.height) - 2 * controllButtonSize.height) / Tile.size.height)

        self.tileMap = TileMap(mapSize: self.mapSize)

        self.player = Player(tileMap: self.tileMap)

        super.init(size: size)

        self.scaleMode = SKSceneScaleMode.ResizeFill
        self.backgroundColor = SKColor(red: 38/255, green: 35/255, blue: 58/255, alpha: 1)

        self.tileMap.position = CGPoint(x: 0, y: 2 * controllButtonSize.height)

        // Add to scene
        self.tileMap.addChild(self.player)
        self.addChild(tileMap)

        self.buttonUp = SKSpriteNode(imageNamed: "buttonUp")
        self.buttonUp!.position = CGPoint(x: CGFloat(self.controllButtonSize.width / 2 + 15), y: CGFloat(self.controllButtonSize.height) * 1.5)
        self.buttonUp!.name = "buttonUp"
        self.buttonUp!.zPosition = 10

        self.addChild(self.buttonUp!)

        self.buttonDown = SKSpriteNode(imageNamed: "buttonDown")
        self.buttonDown!.position = CGPoint(x: self.controllButtonSize.width / 2 + 15, y: self.controllButtonSize.height / 2)
        self.buttonDown!.name = "buttonDown"
        self.buttonDown!.zPosition = 10

        self.addChild(self.buttonDown!)

        self.buttonRight = SKSpriteNode(imageNamed: "buttonRight")
        self.buttonRight!.position = CGPoint(x: CGRectGetMaxX(self.frame) - CGFloat(self.controllButtonSize.width / 2), y: CGFloat(self.controllButtonSize.height))
        self.buttonRight!.name = "buttonRight"
        self.buttonRight!.zPosition = 10

        self.addChild(self.buttonRight!)

        self.buttonLeft = SKSpriteNode(imageNamed: "buttonLeft")
        self.buttonLeft!.position = CGPoint(x: CGRectGetMaxX(self.frame) - CGFloat(self.controllButtonSize.width) * 1.5, y: CGFloat(self.controllButtonSize.height))
        self.buttonLeft!.name = "buttonLeft"
        self.buttonLeft!.zPosition = 10

        self.addChild(self.buttonLeft!)

        self.buttonCheat = SKLabelNode(text: "CHEAT")
        self.buttonCheat!.fontSize = 45
        self.buttonCheat!.fontColor = SKColor(red: 205/255, green: 202/255, blue: 219/255, alpha: 1)
        self.buttonCheat!.position = CGPointMake(CGRectGetMidX(self.frame), 45)
        
        
        self.addChild(self.buttonCheat!)

    }

    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not beed implemented")
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let positionInScene = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(positionInScene)

            switch touchedNode {
            case buttonUp!:
                self.player.move(Direction.Up)
            case buttonDown!:
                self.player.move(Direction.Down)
            case buttonRight!:
                self.player.move(Direction.Right)
            case buttonLeft!:
                self.player.move(Direction.Left)
            case buttonCheat!:
                let path = tileMap.findShortestPathToExit((x: Int(self.player.coord.x), y: Int(self.player.coord.y)), exitCoords: (x: Int(tileMap.exitCoords.x), y: Int(tileMap.exitCoords.y)))

                showPath(path)

                tileMap.runAction(SKAction.sequence([
                    SKAction.waitForDuration(3.0),

                    SKAction.runBlock({ 
                        self.enumerateChildNodesWithName("Path", usingBlock: { node,_ in
                            node.removeFromParent()
                        })
                    })
                    ]))

            default:
                break
            }

        }
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if player.coord == tileMap.exitCoords {
            let gameOverScene = GameOverScene(size: self.size)

            self.view?.presentScene(gameOverScene)
        }
    }

    private func showPath(path: [(x: Int, y: Int)]) {
        for i in path {
            let tile = Tile(type: TileType.Path, coord: (i.x, i.y))
            let tilePositionInMap = tileMap.tilePositionForCoord((i.x, i.y))
            
            tile.position.x = tileMap.position.x + tilePositionInMap.x
            tile.position.y = tileMap.position.y + tilePositionInMap.y
            tile.zPosition = 100
            tile.name = "Path"
            
            self.addChild(tile)
        }
    }
}
